using System;
using System.Collections.Generic;
using System.IO;
using Xunit;
using AlphacamAddins.Examples;

namespace AlphacamAddins.Tests.Examples
{
    // ─────────────────────────────────────────────────────────────────────────
    // Fake / stub implementations of the Alphacam interfaces.
    // These run entirely in memory — no Alphacam installation required.
    // ─────────────────────────────────────────────────────────────────────────

    internal sealed class FakePath : IAlphacamPath
    {
        public bool Selected { get; set; }
        public int LeadInCallCount { get; private set; }

        public void SetLeadInOutAuto(int leadTypeIn, int leadTypeOut,
            double overlapIn, double overlapOut, double angle,
            bool arcEntry, bool arcExit, double radius)
        {
            LeadInCallCount++;
        }

        public void Release() { }
    }

    internal sealed class FakeToolpaths : IAlphacamToolpaths
    {
        private readonly List<FakePath> _paths;

        public FakeToolpaths(int count)
        {
            _paths = new List<FakePath>(count);
            for (int i = 0; i < count; i++)
                _paths.Add(new FakePath());
        }

        public int Count => _paths.Count;

        public IAlphacamPath Item(int index) => _paths[index - 1]; // 1-based

        public List<FakePath> Paths => _paths;

        public void Release() { }
    }

    internal sealed class FakeMillData : IAlphacamMillData
    {
        public float SafeRapidLevel { get; set; }
        public float RapidDownTo    { get; set; }
        public float MaterialTop    { get; set; }
        public float FinalDepth     { get; set; }
        public float Stock          { get; set; }
        public float StepLength     { get; set; }
        public float ChordError     { get; set; }
        public int   McComp         { get; set; }
        public int   EngraveType    { get; set; }

        /// <summary>Number of toolpaths to return from RoughFinish() / Engrave().</summary>
        public int FakeToolpathCount { get; set; } = 3;

        public FakeToolpaths? LastToolpaths { get; private set; }

        public IAlphacamToolpaths RoughFinish()
        {
            LastToolpaths = new FakeToolpaths(FakeToolpathCount);
            return LastToolpaths;
        }

        public IAlphacamToolpaths Engrave()
        {
            LastToolpaths = new FakeToolpaths(FakeToolpathCount);
            return LastToolpaths;
        }

        public void Release() { }
    }

    internal sealed class FakeMillTool : IAlphacamMillTool
    {
        public void Release() { }
    }

    internal sealed class FakeDrawing : IAlphacamDrawing
    {
        private readonly FakePathCollection _geos;
        public FakeDrawing(int geoCount) => _geos = new FakePathCollection(geoCount);
        public IAlphacamPathCollection Geometries => _geos;
        public FakePathCollection FakeGeos => _geos;
    }

    internal sealed class FakePathCollection : IAlphacamPathCollection
    {
        private readonly List<FakePath> _items;

        public FakePathCollection(int count)
        {
            _items = new List<FakePath>(count);
            for (int i = 0; i < count; i++)
                _items.Add(new FakePath());
        }

        public int Count => _items.Count;
        public IAlphacamPath Item(int index) => _items[index - 1];
        public List<FakePath> Paths => _items;
    }

    internal sealed class FakeAlphacamApp : IAlphacamApp
    {
        private readonly FakeDrawing _drawing;
        private readonly FakeMillData _millData;
        public bool ToolFound { get; set; } = true;

        public FakeAlphacamApp(int geoCount = 2, int toolpathCount = 3)
        {
            _drawing  = new FakeDrawing(geoCount);
            _millData = new FakeMillData { FakeToolpathCount = toolpathCount };
        }

        public IAlphacamDrawing ActiveDrawing => _drawing;
        public FakeDrawing FakeDrawing        => _drawing;
        public FakeMillData FakeMillData      => _millData;

        public IAlphacamMillTool? SelectTool(string toolPath) =>
            ToolFound ? new FakeMillTool() : null;

        public IAlphacamMillData CreateMillData() => _millData;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Tests
    // ─────────────────────────────────────────────────────────────────────────

    /// <summary>
    /// Unit tests for <see cref="SolidMachiningAddin"/>.
    /// All tests run without Alphacam installed.
    /// </summary>
    public class SolidMachiningAddinTests : IDisposable
    {
        private readonly string _tempDir;

        public SolidMachiningAddinTests()
        {
            _tempDir = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());
            Directory.CreateDirectory(_tempDir);
        }

        public void Dispose()
        {
            if (Directory.Exists(_tempDir))
                Directory.Delete(_tempDir, recursive: true);
        }

        // ── Config loading ────────────────────────────────────────────────

        [Fact]
        public void LoadConfig_ValidJson_ParsesOperations()
        {
            string json = @"{
                ""operations"": [
                    {
                        ""name"": ""Roughing"",
                        ""type"": ""RoughFinish"",
                        ""tool"": ""flat20mm.art"",
                        ""safe_rapid"": 50.0,
                        ""rapid_down_to"": 5.0,
                        ""material_top"": 0.0,
                        ""final_depth"": -30.0,
                        ""stock"": 0.5,
                        ""step_length"": 2.0,
                        ""chord_error"": 0.05,
                        ""lead_in"": true,
                        ""compensation"": ""ToolCentre""
                    }
                ]
            }";
            string path = WriteConfig(json);

            MachiningConfig config = SolidMachiningAddin.LoadConfig(path);

            Assert.Single(config.Operations);
            MachiningOperation op = config.Operations[0];
            Assert.Equal("Roughing",          op.Name);
            Assert.Equal(StrategyType.RoughFinish, op.Type);
            Assert.Equal("flat20mm.art",       op.Tool);
            Assert.Equal(50.0f,                op.SafeRapid);
            Assert.Equal(-30.0f,               op.FinalDepth);
            Assert.Equal(0.5f,                 op.Stock);
            Assert.True(op.LeadIn);
        }

        [Fact]
        public void LoadConfig_MultipleOperations_ParsesAll()
        {
            string json = @"{
                ""operations"": [
                    { ""name"": ""Op1"", ""type"": ""RoughFinish"", ""tool"": ""a.art"" },
                    { ""name"": ""Op2"", ""type"": ""Engrave"",     ""tool"": ""b.art"" }
                ]
            }";
            MachiningConfig config = SolidMachiningAddin.LoadConfig(WriteConfig(json));

            Assert.Equal(2,                    config.Operations.Count);
            Assert.Equal(StrategyType.RoughFinish, config.Operations[0].Type);
            Assert.Equal(StrategyType.Engrave,     config.Operations[1].Type);
        }

        [Fact]
        public void LoadConfig_MissingFile_ThrowsFileNotFoundException()
        {
            Assert.Throws<FileNotFoundException>(
                () => SolidMachiningAddin.LoadConfig("/nonexistent/path/config.json"));
        }

        [Fact]
        public void LoadConfig_EmptyOperationsList_ParsesSuccessfully()
        {
            string json = @"{ ""operations"": [] }";
            MachiningConfig config = SolidMachiningAddin.LoadConfig(WriteConfig(json));
            Assert.Empty(config.Operations);
        }

        // ── MapCompensation ───────────────────────────────────────────────

        [Theory]
        [InlineData("ToolCentre", 0)]
        [InlineData("toolcentre", 0)]
        [InlineData("TOOLCENTRE", 0)]
        [InlineData("Left",  1)]
        [InlineData("LEFT",  1)]
        [InlineData("Right", 2)]
        [InlineData("RIGHT", 2)]
        [InlineData("",      0)]  // unknown → ToolCentre
        [InlineData("none",  0)]  // unknown → ToolCentre
        public void MapCompensation_ReturnsExpectedValue(string input, int expected)
        {
            Assert.Equal(expected, SolidMachiningAddin.MapCompensation(input));
        }

        // ── Execute — RoughFinish strategy ───────────────────────────────

        [Fact]
        public void Execute_RoughFinishOperation_SetsMillDataParameters()
        {
            FakeAlphacamApp app = new FakeAlphacamApp(geoCount: 1, toolpathCount: 2);
            string configPath = WriteConfig(BuildSingleOpConfig(
                type: "RoughFinish",
                safeRapid: 50.0f, rapidDownTo: 5.0f,
                materialTop: 0.0f, finalDepth: -25.0f,
                stock: 0.5f, stepLength: 2.0f, chordError: 0.05f,
                leadIn: false, compensation: "Left"));

            var addin = new SolidMachiningAddin(app, configPath);
            addin.Execute();

            FakeMillData md = app.FakeMillData;
            Assert.Equal(50.0f, md.SafeRapidLevel);
            Assert.Equal(5.0f,  md.RapidDownTo);
            Assert.Equal(0.0f,  md.MaterialTop);
            Assert.Equal(-25.0f, md.FinalDepth);
            Assert.Equal(0.5f,  md.Stock);
            Assert.Equal(2.0f,  md.StepLength);
            Assert.Equal(0.05f, md.ChordError);
            Assert.Equal(1,     md.McComp);  // Left
        }

        [Fact]
        public void Execute_RoughFinishOperation_ReturnsCorrectToolpathCount()
        {
            FakeAlphacamApp app = new FakeAlphacamApp(toolpathCount: 4);
            string configPath = WriteConfig(BuildSingleOpConfig("RoughFinish"));

            var addin = new SolidMachiningAddin(app, configPath);
            int count = addin.Execute();

            Assert.Equal(4, count);
        }

        // ── Execute — Engrave strategy ────────────────────────────────────

        [Fact]
        public void Execute_EngraveOperation_SetsEngraveType()
        {
            FakeAlphacamApp app = new FakeAlphacamApp();
            string configPath = WriteConfig(BuildSingleOpConfig("Engrave"));

            var addin = new SolidMachiningAddin(app, configPath);
            addin.Execute();

            Assert.Equal(0, app.FakeMillData.EngraveType); // acamEngraveGEOMETRIES
        }

        [Fact]
        public void Execute_EngraveOperation_ReturnsCorrectToolpathCount()
        {
            FakeAlphacamApp app = new FakeAlphacamApp(toolpathCount: 2);
            string configPath = WriteConfig(BuildSingleOpConfig("Engrave"));

            var addin = new SolidMachiningAddin(app, configPath);
            int count = addin.Execute();

            Assert.Equal(2, count);
        }

        // ── Execute — geometry selection ──────────────────────────────────

        [Fact]
        public void Execute_SelectsAllGeometryInDrawing()
        {
            FakeAlphacamApp app = new FakeAlphacamApp(geoCount: 5);
            string configPath = WriteConfig(BuildSingleOpConfig("RoughFinish"));

            new SolidMachiningAddin(app, configPath).Execute();

            foreach (FakePath path in app.FakeDrawing.FakeGeos.Paths)
                Assert.True(path.Selected, "All geometry should be selected before machining.");
        }

        // ── Execute — lead-in/lead-out ─────────────────────────────────────

        [Fact]
        public void Execute_WithLeadIn_CallsSetLeadInOutAutoOnEachToolpath()
        {
            FakeAlphacamApp app = new FakeAlphacamApp(toolpathCount: 3);
            string configPath = WriteConfig(BuildSingleOpConfig("RoughFinish", leadIn: true));

            new SolidMachiningAddin(app, configPath).Execute();

            FakeToolpaths? tps = app.FakeMillData.LastToolpaths;
            Assert.NotNull(tps);
            foreach (FakePath tp in tps!.Paths)
                Assert.Equal(1, tp.LeadInCallCount);
        }

        [Fact]
        public void Execute_WithoutLeadIn_DoesNotCallSetLeadInOutAuto()
        {
            FakeAlphacamApp app = new FakeAlphacamApp(toolpathCount: 2);
            string configPath = WriteConfig(BuildSingleOpConfig("RoughFinish", leadIn: false));

            new SolidMachiningAddin(app, configPath).Execute();

            FakeToolpaths? tps = app.FakeMillData.LastToolpaths;
            Assert.NotNull(tps);
            foreach (FakePath tp in tps!.Paths)
                Assert.Equal(0, tp.LeadInCallCount);
        }

        // ── Execute — multiple operations ─────────────────────────────────

        [Fact]
        public void Execute_TwoOperations_ReturnsSumOfToolpaths()
        {
            // Each call to CreateMillData() returns the same FakeMillData,
            // which reports FakeToolpathCount paths.
            FakeAlphacamApp app = new FakeAlphacamApp(toolpathCount: 3);
            string configPath = WriteConfig(@"{
                ""operations"": [
                    { ""name"": ""Op1"", ""type"": ""RoughFinish"", ""tool"": ""a.art"" },
                    { ""name"": ""Op2"", ""type"": ""Engrave"",     ""tool"": ""b.art"" }
                ]
            }");

            int total = new SolidMachiningAddin(app, configPath).Execute();

            Assert.Equal(6, total); // 3 + 3
        }

        // ── Execute — error conditions ─────────────────────────────────────

        [Fact]
        public void Execute_EmptyOperationsList_ThrowsInvalidOperationException()
        {
            FakeAlphacamApp app = new FakeAlphacamApp();
            string configPath = WriteConfig(@"{ ""operations"": [] }");

            var addin = new SolidMachiningAddin(app, configPath);
            Assert.Throws<InvalidOperationException>(() => addin.Execute());
        }

        [Fact]
        public void Execute_ToolNotFound_ThrowsInvalidOperationException()
        {
            FakeAlphacamApp app = new FakeAlphacamApp();
            app.ToolFound = false;
            string configPath = WriteConfig(BuildSingleOpConfig("RoughFinish"));

            var addin = new SolidMachiningAddin(app, configPath);
            Assert.Throws<InvalidOperationException>(() => addin.Execute());
        }

        [Fact]
        public void Constructor_NullApp_ThrowsArgumentNullException()
        {
            Assert.Throws<ArgumentNullException>(
                () => new SolidMachiningAddin(null!, "config.json"));
        }

        // ── Helpers ───────────────────────────────────────────────────────

        private string WriteConfig(string json)
        {
            string path = Path.Combine(_tempDir, $"{Guid.NewGuid()}.json");
            File.WriteAllText(path, json);
            return path;
        }

        private static string BuildSingleOpConfig(
            string type = "RoughFinish",
            float safeRapid = 50.0f, float rapidDownTo = 5.0f,
            float materialTop = 0.0f, float finalDepth = -30.0f,
            float stock = 0.0f, float stepLength = 1.0f, float chordError = 0.05f,
            bool leadIn = false, string compensation = "ToolCentre")
        {
            return $@"{{
                ""operations"": [
                    {{
                        ""name"": ""TestOp"",
                        ""type"": ""{type}"",
                        ""tool"": ""test-tool.art"",
                        ""safe_rapid"": {safeRapid},
                        ""rapid_down_to"": {rapidDownTo},
                        ""material_top"": {materialTop},
                        ""final_depth"": {finalDepth},
                        ""stock"": {stock},
                        ""step_length"": {stepLength},
                        ""chord_error"": {chordError},
                        ""lead_in"": {(leadIn ? "true" : "false")},
                        ""compensation"": ""{compensation}""
                    }}
                ]
            }}";
        }
    }
}
