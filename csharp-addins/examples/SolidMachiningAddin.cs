using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.InteropServices;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace AlphacamAddins.Examples
{
    // ─────────────────────────────────────────────────────────────────────────
    // Configuration model (deserialised from machining_config.json)
    // ─────────────────────────────────────────────────────────────────────────

    /// <summary>
    /// Root configuration object loaded from machining_config.json.
    /// Place this file in the same directory as the part file, or specify a
    /// central path when constructing <see cref="SolidMachiningAddin"/>.
    /// </summary>
    public class MachiningConfig
    {
        /// <summary>Ordered list of 3D machining operations to apply.</summary>
        [JsonPropertyName("operations")]
        public List<MachiningOperation> Operations { get; set; } = new();
    }

    /// <summary>Supported 3D solid machining strategy types.</summary>
    public enum StrategyType
    {
        /// <summary>
        /// Roughing and/or finishing pass driven off selected solid geometry.
        /// Maps to <c>MillData.RoughFinish()</c>.
        /// </summary>
        RoughFinish,

        /// <summary>
        /// 3D engraving / drive-surface finishing pass.
        /// Maps to <c>MillData.Engrave()</c>.
        /// </summary>
        Engrave
    }

    /// <summary>
    /// A single 3D machining operation entry in the configuration file.
    /// All depth/height values are in the drawing's native units (typically mm).
    /// </summary>
    public class MachiningOperation
    {
        /// <summary>Human-readable label shown in progress messages.</summary>
        [JsonPropertyName("name")]
        public string Name { get; set; } = string.Empty;

        /// <summary>Machining strategy to execute.</summary>
        [JsonPropertyName("type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public StrategyType Type { get; set; }

        /// <summary>Full path to the Alphacam tool file (.art).</summary>
        [JsonPropertyName("tool")]
        public string Tool { get; set; } = string.Empty;

        /// <summary>Z height of the safe rapid clearance plane.</summary>
        [JsonPropertyName("safe_rapid")]
        public float SafeRapid { get; set; }

        /// <summary>Z height at which the rapid feed transitions to cutting feed.</summary>
        [JsonPropertyName("rapid_down_to")]
        public float RapidDownTo { get; set; }

        /// <summary>Z height of the top surface of the raw material.</summary>
        [JsonPropertyName("material_top")]
        public float MaterialTop { get; set; }

        /// <summary>Final Z depth of cut (negative = below material top).</summary>
        [JsonPropertyName("final_depth")]
        public float FinalDepth { get; set; }

        /// <summary>Amount of material stock left after this operation (roughing passes).</summary>
        [JsonPropertyName("stock")]
        public float Stock { get; set; }

        /// <summary>Step distance between passes (stepover / step-down depending on strategy).</summary>
        [JsonPropertyName("step_length")]
        public float StepLength { get; set; } = 1.0f;

        /// <summary>Maximum chord error for arc/spline approximation.</summary>
        [JsonPropertyName("chord_error")]
        public float ChordError { get; set; } = 0.05f;

        /// <summary>Whether to apply automatic lead-in and lead-out to each toolpath.</summary>
        [JsonPropertyName("lead_in")]
        public bool LeadIn { get; set; }

        /// <summary>
        /// Cutter compensation mode.
        /// Valid values: "ToolCentre", "Left", "Right".
        /// Defaults to "ToolCentre" (no compensation) if omitted.
        /// </summary>
        [JsonPropertyName("compensation")]
        public string Compensation { get; set; } = "ToolCentre";
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Thin interfaces wrapping Alphacam COM objects
    // These interfaces let us unit-test the addin without Alphacam installed.
    // In production the concrete wrappers delegate to the real COM objects.
    // ─────────────────────────────────────────────────────────────────────────

    /// <summary>Minimal surface of the Alphacam Application COM object needed by this addin.</summary>
    public interface IAlphacamApp
    {
        IAlphacamDrawing ActiveDrawing { get; }
        IAlphacamMillTool? SelectTool(string toolPath);
        IAlphacamMillData CreateMillData();
    }

    /// <summary>Minimal surface of a Drawing COM object.</summary>
    public interface IAlphacamDrawing
    {
        IAlphacamPathCollection Geometries { get; }
    }

    /// <summary>Minimal surface of a Path collection COM object.</summary>
    public interface IAlphacamPathCollection
    {
        int Count { get; }
        IAlphacamPath Item(int index);
    }

    /// <summary>Minimal surface of an individual geometry Path COM object.</summary>
    public interface IAlphacamPath
    {
        bool Selected { get; set; }
        void SetLeadInOutAuto(int leadTypeIn, int leadTypeOut,
            double overlapIn, double overlapOut, double angle,
            bool arcEntry, bool arcExit, double radius);
        void Release();
    }

    /// <summary>Minimal surface of the MillTool COM object.</summary>
    public interface IAlphacamMillTool
    {
        void Release();
    }

    /// <summary>Minimal surface of the MillData COM object used by this addin.</summary>
    public interface IAlphacamMillData
    {
        float SafeRapidLevel { get; set; }
        float RapidDownTo { get; set; }
        float MaterialTop { get; set; }
        float FinalDepth { get; set; }
        float Stock { get; set; }
        float StepLength { get; set; }
        float ChordError { get; set; }
        int McComp { get; set; }
        int EngraveType { get; set; }

        /// <summary>Executes roughing/finishing; returns generated toolpaths.</summary>
        IAlphacamToolpaths RoughFinish();

        /// <summary>Executes 3D engrave / drive-surface; returns generated toolpaths.</summary>
        IAlphacamToolpaths Engrave();

        void Release();
    }

    /// <summary>Minimal surface of the Paths (toolpath collection) COM object.</summary>
    public interface IAlphacamToolpaths
    {
        int Count { get; }
        IAlphacamPath Item(int index);
        void Release();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Cutter compensation enum values (mirror acamapi AcamComp enumeration)
    // ─────────────────────────────────────────────────────────────────────────

    internal static class AcamComp
    {
        public const int ToolCentre = 0;
        public const int Left       = 1;
        public const int Right      = 2;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Main addin class
    // ─────────────────────────────────────────────────────────────────────────

    /// <summary>
    /// Per-part 3D solid-defined machining automation add-in.
    ///
    /// <para>
    /// This add-in reads a user-supplied <c>machining_config.json</c> file,
    /// selects all solid/surface geometry in the active drawing, and applies
    /// each configured 3D machining operation in order using Alphacam's
    /// <c>MillData</c> API — without relying on layers or the Automation Manager.
    /// </para>
    ///
    /// <para>
    /// Run this add-in on each part <em>before</em> sending it to the nesting
    /// pipeline so that toolpaths are already attached to the drawing.
    /// </para>
    ///
    /// <para>
    /// <b>Language note</b>: The Alphacam COM API is also consumable from
    /// Python (via <c>pywin32</c>) and C++ (via COM <c>#import</c>). C# is
    /// recommended for in-process add-ins; Python is convenient for
    /// out-of-process scripting and rapid prototyping. See
    /// <c>docs/guides/3d-solid-machining-automation.md</c> for the full
    /// roadmap and Python example code.
    /// </para>
    /// </summary>
    public class SolidMachiningAddin
    {
        private readonly IAlphacamApp _acam;
        private readonly string _configPath;

        /// <summary>
        /// Constructs the addin.
        /// </summary>
        /// <param name="acam">
        ///   Alphacam application interface. In production, pass the real
        ///   <c>IAlphaCamApp</c> COM object wrapped in a thin adapter. In tests,
        ///   pass a mock that implements <see cref="IAlphacamApp"/>.
        /// </param>
        /// <param name="configPath">
        ///   Path to <c>machining_config.json</c>. Defaults to a file named
        ///   <c>machining_config.json</c> in the same directory as the addin DLL.
        /// </param>
        public SolidMachiningAddin(IAlphacamApp acam, string? configPath = null)
        {
            _acam = acam ?? throw new ArgumentNullException(nameof(acam));
            _configPath = configPath
                ?? Path.Combine(AppContext.BaseDirectory, "machining_config.json");
        }

        /// <summary>
        /// Loads the configuration and applies each 3D machining operation
        /// to the active drawing in order.
        /// </summary>
        /// <returns>
        ///   Total number of toolpaths created across all operations.
        /// </returns>
        /// <exception cref="FileNotFoundException">
        ///   Thrown when <see cref="_configPath"/> does not exist.
        /// </exception>
        /// <exception cref="InvalidOperationException">
        ///   Thrown when the configuration contains no operations.
        /// </exception>
        public int Execute()
        {
            MachiningConfig config = LoadConfig(_configPath);

            if (config.Operations.Count == 0)
                throw new InvalidOperationException(
                    $"No operations found in '{_configPath}'. " +
                    "Add at least one entry to the 'operations' array.");

            IAlphacamDrawing drw = _acam.ActiveDrawing;
            SelectAllGeometry(drw);

            int totalToolpaths = 0;
            foreach (MachiningOperation op in config.Operations)
                totalToolpaths += ApplyOperation(op);

            return totalToolpaths;
        }

        // ── Configuration loading ─────────────────────────────────────────

        /// <summary>Deserialises the JSON configuration file.</summary>
        public static MachiningConfig LoadConfig(string path)
        {
            if (!File.Exists(path))
                throw new FileNotFoundException(
                    $"Machining configuration not found: '{path}'", path);

            string json = File.ReadAllText(path);
            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true,
                Converters = { new JsonStringEnumConverter() }
            };
            return JsonSerializer.Deserialize<MachiningConfig>(json, options)
                   ?? throw new InvalidOperationException(
                       $"Failed to parse machining configuration from '{path}'.");
        }

        // ── Geometry selection ────────────────────────────────────────────

        /// <summary>
        /// Selects all geometry in the drawing so that the subsequent
        /// MillData operation acts on the entire solid/surface model.
        ///
        /// For selective face-based machining, replace this method with
        /// Feature-API calls that inspect face normals, areas, or feature
        /// types and select only the faces relevant to each operation.
        /// </summary>
        private static void SelectAllGeometry(IAlphacamDrawing drw)
        {
            IAlphacamPathCollection geos = drw.Geometries;
            for (int i = 1; i <= geos.Count; i++)
            {
                IAlphacamPath geo = geos.Item(i);
                geo.Selected = true;
                geo.Release();
            }
        }

        // ── Operation dispatch ────────────────────────────────────────────

        /// <summary>
        /// Applies a single configured operation and returns the number of
        /// toolpaths created.
        /// </summary>
        private int ApplyOperation(MachiningOperation op)
        {
            IAlphacamMillTool? tool = _acam.SelectTool(op.Tool);
            if (tool == null)
                throw new InvalidOperationException(
                    $"Tool not found for operation '{op.Name}': {op.Tool}");

            try
            {
                return op.Type switch
                {
                    StrategyType.RoughFinish => ApplyRoughFinish(op),
                    StrategyType.Engrave     => ApplyEngrave(op),
                    _ => throw new NotSupportedException(
                             $"Unknown strategy type: {op.Type}")
                };
            }
            finally
            {
                tool.Release();
            }
        }

        /// <summary>
        /// Executes a roughing/finishing pass using <c>MillData.RoughFinish()</c>.
        /// </summary>
        private int ApplyRoughFinish(MachiningOperation op)
        {
            IAlphacamMillData md = _acam.CreateMillData();
            try
            {
                md.SafeRapidLevel = op.SafeRapid;
                md.RapidDownTo    = op.RapidDownTo;
                md.MaterialTop    = op.MaterialTop;
                md.FinalDepth     = op.FinalDepth;
                md.Stock          = op.Stock;
                md.StepLength     = op.StepLength;
                md.ChordError     = op.ChordError;
                md.McComp         = MapCompensation(op.Compensation);

                IAlphacamToolpaths paths = md.RoughFinish();
                try
                {
                    if (op.LeadIn)
                        AddLeadInOut(paths);
                    return paths.Count;
                }
                finally
                {
                    paths.Release();
                }
            }
            finally
            {
                md.Release();
            }
        }

        /// <summary>
        /// Executes a 3D drive-surface engrave pass using <c>MillData.Engrave()</c>.
        /// </summary>
        private int ApplyEngrave(MachiningOperation op)
        {
            IAlphacamMillData md = _acam.CreateMillData();
            try
            {
                md.SafeRapidLevel = op.SafeRapid;
                md.RapidDownTo    = op.RapidDownTo;
                md.MaterialTop    = op.MaterialTop;
                md.FinalDepth     = op.FinalDepth;
                md.StepLength     = op.StepLength;
                md.ChordError     = op.ChordError;
                md.EngraveType    = 0; // acamEngraveGEOMETRIES

                IAlphacamToolpaths paths = md.Engrave();
                try
                {
                    if (op.LeadIn)
                        AddLeadInOut(paths);
                    return paths.Count;
                }
                finally
                {
                    paths.Release();
                }
            }
            finally
            {
                md.Release();
            }
        }

        // ── Lead-in / Lead-out ────────────────────────────────────────────

        /// <summary>
        /// Applies automatic lead-in and lead-out to every toolpath in <paramref name="paths"/>.
        /// The lead parameters here are conservative defaults; tune them for your tooling.
        /// </summary>
        private static void AddLeadInOut(IAlphacamToolpaths paths)
        {
            const int LeadBoth  = 3;   // acamLeadBOTH
            const double Overlap = 1.2;
            const double Angle   = 45.0;

            for (int i = 1; i <= paths.Count; i++)
            {
                IAlphacamPath tp = paths.Item(i);
                try
                {
                    tp.SetLeadInOutAuto(LeadBoth, LeadBoth, Overlap, Overlap,
                        Angle, false, false, 0.0);
                }
                finally
                {
                    tp.Release();
                }
            }
        }

        // ── Helpers ───────────────────────────────────────────────────────

        /// <summary>
        /// Maps the human-readable compensation string from the config file to
        /// the integer value expected by <c>MillData.McComp</c> (AcamComp enum).
        /// </summary>
        public static int MapCompensation(string compensation) =>
            compensation?.ToUpperInvariant() switch
            {
                "LEFT"       => AcamComp.Left,
                "RIGHT"      => AcamComp.Right,
                "TOOLCENTRE" => AcamComp.ToolCentre,
                _            => AcamComp.ToolCentre
            };
    }
}
