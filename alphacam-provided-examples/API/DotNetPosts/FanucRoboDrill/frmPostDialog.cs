using AlphaCAMMill;
using System;
using System.Drawing;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace FanucRobodrill
{

    public partial class frmPostDialog : Form
    {
        IAlphaCamApp Acam;
        PostData PD;
		string iniFileName;
		string txtFileName;

        public string Description { get; set; }
        public string Revision { get; set; }
        public string Material { get; set; }
        public string Programmer { get; set; }
        public string PanelX { get; set; }
        public string PanelY { get; set; }
        public string PanelZ { get; set; }
        public int Origin { get; set; }

        public string OffsetX { get; set; }
        public string OffsetY { get; set; }
        public string OffsetZ { get; set; }

        public const int dec_p = 2;

        public frmPostDialog(IAlphaCamApp Acam, PostData PD)
        {
            // Store App object in class
            this.Acam = Acam;
            this.PD = PD;
            
			iniFileName = FileUtils.IniFilename();
			txtFileName = FileUtils.TextFilename();

            InitializeComponent();
            ReadStringsFromTextFile();

            ReadDefaultsFromIni();
        }


        private void btnOK_Click(object sender, EventArgs e)
        {
            Description = txtDescription.Text;
            Revision = txtRevision.Text;
            Material = txtMaterial.Text;
            Programmer = txtProgrammer.Text;
            PanelX = txtLength.Text;
            PanelY = txtWidth.Text;
            PanelZ = txtThickness.Text;
            OffsetX = txtOffsetX.Text;
            OffsetY = txtOffsetY.Text;
            OffsetZ = txtOffsetZ.Text;

            Drawing Drw = Acam.ActiveDrawing;

            Drw.Attribute["Settings"] = 1;
            Drw.Attribute["OffsetX"] = OffsetX;
            Drw.Attribute["OffsetY"] = OffsetY;
            Drw.Attribute["OffsetZ"] = OffsetZ;
            Drw.Attribute["Origin"] = Origin;

			Marshal.ReleaseComObject(Drw);
        }

        private void frmSettings_Load(object sender, EventArgs e)
        {           
            txtDescription.Text = Description;
            txtRevision.Text = Revision;
            txtMaterial.Text = Material;
            txtProgrammer.Text = Programmer;

            if (Math.Round(PD.Vars.HXW - PD.Vars.LXW, 3) > 0)
            {
                optWorkVolume.Checked = true;
                optWorkVolume_CheckedChanged(sender, new EventArgs());
            }
            else if (Math.Round(PD.Vars.WHX - PD.Vars.WLX, dec_p) > 0)
            {
                optMaterial.Checked = true;
                optMaterial_CheckedChanged(sender, new EventArgs());
            }
            else
            {
                optManual.Checked = true;
                optManual_CheckedChanged(sender, new EventArgs());
            }

            ReadValuesFromDrawing(sender, new EventArgs());
        }

        private void optWorkVolume_CheckedChanged(object sender, EventArgs e)
        {
            txtLength.Text = Convert.ToString(Math.Round(PD.Vars.HXW - PD.Vars.LXW, dec_p)).Replace(",", "."); 
            txtWidth.Text = Convert.ToString(Math.Round(PD.Vars.HYW - PD.Vars.LYW, dec_p)).Replace(",", ".");
            txtThickness.Text = Convert.ToString(Math.Round(PD.Vars.HZW - PD.Vars.LZW, dec_p)).Replace(",", ".");

            Reset_Panel();

            Font defaultFont = SystemFonts.DefaultFont;
            optWorkVolume.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Bold);
            optWorkVolume.ForeColor = Color.Red;
        }

        private void optMaterial_CheckedChanged(object sender, EventArgs e)
        {
            txtLength.Text = Convert.ToString(Math.Round(PD.Vars.WHX - PD.Vars.WLX, dec_p)).Replace(",", ".");
            txtWidth.Text = Convert.ToString(Math.Round(PD.Vars.WHY - PD.Vars.WLY, dec_p)).Replace(",", ".");
            txtThickness.Text = Convert.ToString(Math.Round(PD.Vars.WHZ - PD.Vars.WLZ, dec_p)).Replace(",", ".");

            Reset_Panel();

            Font defaultFont = SystemFonts.DefaultFont;
            optMaterial.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Bold);
            optMaterial.ForeColor = Color.Red;
        }

        private void optManual_CheckedChanged(object sender, EventArgs e)
        {
            txtLength.Text = "0";
            txtWidth.Text = "0";
            txtThickness.Text = "0";

            Reset_Panel();

            Font defaultFont = SystemFonts.DefaultFont;
            optManual.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Bold);
            optManual.ForeColor = Color.Red;
        }

        private void optOrigin_1_CheckedChanged(object sender, EventArgs e)
        {
            Origin = 54;

            Reset_Origin();

            Font defaultFont = SystemFonts.DefaultFont;
            optOrigin_1.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Bold);
            optOrigin_1.ForeColor = Color.Red;
        }

        private void optOrigin_2_CheckedChanged(object sender, EventArgs e)
        {
            Origin = 55;

            Reset_Origin();

            Font defaultFont = SystemFonts.DefaultFont;
            optOrigin_2.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Bold);
            optOrigin_2.ForeColor = Color.Red;
        }

        private void optOrigin_3_CheckedChanged(object sender, EventArgs e)
        {
            Origin = 56;

            Reset_Origin();

            Font defaultFont = SystemFonts.DefaultFont;
            optOrigin_3.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Bold);
            optOrigin_3.ForeColor = Color.Red;
        }

        private void optOrigin_4_CheckedChanged(object sender, EventArgs e)
        {
            Origin = 57;

            Reset_Origin();

            Font defaultFont = SystemFonts.DefaultFont;
            optOrigin_4.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Bold);
            optOrigin_4.ForeColor = Color.Red;
        }

        private void optOrigin_5_CheckedChanged(object sender, EventArgs e)
        {
            Origin = 58;

            Reset_Origin();

            Font defaultFont = SystemFonts.DefaultFont;
            optOrigin_5.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Bold);
            optOrigin_5.ForeColor = Color.Red;
        }

        private void optOrigin_6_CheckedChanged(object sender, EventArgs e)
        {
            Origin = 59;

            Reset_Origin();

            Font defaultFont = SystemFonts.DefaultFont;
            optOrigin_6.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Bold);
            optOrigin_6.ForeColor = Color.Red;
        }

        public void Reset_Origin()
        {
            Font defaultFont = SystemFonts.DefaultFont;
            optOrigin_1.ForeColor = Control.DefaultForeColor;
            optOrigin_2.ForeColor = Control.DefaultForeColor;
            optOrigin_3.ForeColor = Control.DefaultForeColor;
            optOrigin_4.ForeColor = Control.DefaultForeColor;
            optOrigin_5.ForeColor = Control.DefaultForeColor;
            optOrigin_6.ForeColor = Control.DefaultForeColor;

            optOrigin_1.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Regular);
            optOrigin_2.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Regular);
            optOrigin_3.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Regular);
            optOrigin_4.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Regular);
            optOrigin_5.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Regular);
            optOrigin_6.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Regular);
		}

        public void Reset_Panel()
        {
            Font defaultFont = SystemFonts.DefaultFont;
            optWorkVolume.ForeColor = Control.DefaultForeColor;
            optMaterial.ForeColor = Control.DefaultForeColor;
            optManual.ForeColor = Control.DefaultForeColor;            
            
            optWorkVolume.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Regular);
            optMaterial.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Regular);
            optManual.Font = new Font(defaultFont.FontFamily, defaultFont.Size, FontStyle.Regular);
        }
        private void btnDefault1_Click(object sender, EventArgs e)
        {
			IFrame Frm = Acam.Frame;
            txtOffsetX.Text = Frm.ReadTextFile(iniFileName, 20, 2);
            txtOffsetY.Text = Frm.ReadTextFile(iniFileName, 20, 3);
            txtOffsetZ.Text = Frm.ReadTextFile(iniFileName, 20, 4);
			Marshal.ReleaseComObject(Frm);
        }

        private void btnDefault2_Click(object sender, EventArgs e)
        {
			IFrame frame = Acam.Frame;
            txtOffsetX.Text = frame.ReadTextFile(iniFileName, 30, 2);
            txtOffsetY.Text = frame.ReadTextFile(iniFileName, 30, 3);
            txtOffsetZ.Text = frame.ReadTextFile(iniFileName, 30, 4);
			Marshal.ReleaseComObject(frame);
        }

        private void btnDefault3_Click(object sender, EventArgs e)
        {
			IFrame Frm = Acam.Frame;
            txtOffsetX.Text = Frm.ReadTextFile(iniFileName, 40, 2);
            txtOffsetY.Text = Frm.ReadTextFile(iniFileName, 40, 3);
            txtOffsetZ.Text = Frm.ReadTextFile(iniFileName, 40, 4);
			Marshal.ReleaseComObject(Frm);
        }

        private void btnDefault4_Click(object sender, EventArgs e)
        {
            IFrame Frm = Acam.Frame;
            txtOffsetX.Text = Frm.ReadTextFile(iniFileName, 50, 2);
            txtOffsetY.Text = Frm.ReadTextFile(iniFileName, 50, 3);
            txtOffsetZ.Text = Frm.ReadTextFile(iniFileName, 50, 4);
			Marshal.ReleaseComObject(Frm);
        }

        private void button1_Click(object sender, EventArgs e)
        {
			IFrame Frm = Acam.Frame;
            txtOffsetX.Text = Frm.ReadTextFile(iniFileName, 60, 2);
            txtOffsetY.Text = Frm.ReadTextFile(iniFileName, 60, 3);
            txtOffsetZ.Text = Frm.ReadTextFile(iniFileName, 60, 4);
			Marshal.ReleaseComObject(Frm);
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {

        }

        private void btnSettings_Click(object sender, EventArgs e)
        {
            using (frmSettingsDialog settingsDialog = new frmSettingsDialog(Acam, PD)) //NEW
            {
                DialogResult dialogresult = settingsDialog.ShowDialog();
            }
        }

        private void ReadDefaultsFromIni ()
        {
			IFrame Frm = Acam.Frame;
            optOrigin_1.Text = Frm.ReadTextFile(iniFileName, 10, 1);
            optOrigin_2.Text = Frm.ReadTextFile(iniFileName, 10, 2);
            optOrigin_3.Text = Frm.ReadTextFile(iniFileName, 10, 3);
            optOrigin_4.Text = Frm.ReadTextFile(iniFileName, 10, 4);
            optOrigin_5.Text = Frm.ReadTextFile(iniFileName, 10, 5);
            optOrigin_6.Text = Frm.ReadTextFile(iniFileName, 10, 6);

            btnDefault1.Text = Frm.ReadTextFile(iniFileName, 20, 1);
            btnDefault2.Text = Frm.ReadTextFile(iniFileName, 30, 1);
            btnDefault3.Text = Frm.ReadTextFile(iniFileName, 40, 1);
            btnDefault4.Text = Frm.ReadTextFile(iniFileName, 50, 1);
            btnReset.Text = Frm.ReadTextFile(iniFileName, 60, 1);

			Marshal.ReleaseComObject(Frm);
        }

        private void ReadValuesFromDrawing(object sender, EventArgs e)
        {
            Drawing Drw = Acam.ActiveDrawing;

            int i;
            int i1;
            try
            {
                i = (int)Drw.Attribute["Settings"];
                txtOffsetX.Text = Convert.ToString((string)Drw.Attribute["OffsetX"]);
                txtOffsetY.Text = Convert.ToString((string)Drw.Attribute["OffsetY"]);
                txtOffsetZ.Text = Convert.ToString((string)Drw.Attribute["OffsetZ"]);

                i1 = (int)Drw.Attribute["Origin"];

                if (i1 == 54)
                {
                    optOrigin_1.Checked = true;
                    optOrigin_1_CheckedChanged(sender, new EventArgs());
                }
                else if (i1 == 55)
                {
                    optOrigin_2.Checked = true;
                    optOrigin_2_CheckedChanged(sender, new EventArgs());
                }
                else if (i1 == 56)
                {
                    optOrigin_3.Checked = true;
                    optOrigin_3_CheckedChanged(sender, new EventArgs());
                }
                else if (i1 == 57)
                {
                    optOrigin_4.Checked = true;
                    optOrigin_4_CheckedChanged(sender, new EventArgs());
                }
                else if (i1 == 58)
                {
                    optOrigin_5.Checked = true;
                    optOrigin_5_CheckedChanged(sender, new EventArgs());
                }
                else if (i1 == 59)
                {
                    optOrigin_6.Checked = true;
                    optOrigin_6_CheckedChanged(sender, new EventArgs());
                }
                else
                {
                    optOrigin_1.Checked = true;
                    optOrigin_1_CheckedChanged(sender, new EventArgs());
                }
            }
            catch
            {
                i = 0;

                button1_Click(sender, e);
                optOrigin_1.Checked = true;
                optOrigin_1_CheckedChanged(sender, new EventArgs());
            }

			Marshal.ReleaseComObject(Drw);
        }

        private void ReadStringsFromTextFile()
        {
			IFrame Frm = Acam.Frame;
            grpPanelSize.Text = Frm.ReadTextFile(txtFileName, 50, 1);
            lblLength.Text = Frm.ReadTextFile(txtFileName, 50, 2);
            lblWidth.Text = Frm.ReadTextFile(txtFileName, 50, 3);
            lblThickness.Text = Frm.ReadTextFile(txtFileName, 50, 4);
            optWorkVolume.Text = Frm.ReadTextFile(txtFileName, 50, 5);
            optMaterial.Text = Frm.ReadTextFile(txtFileName, 50, 6);
            optManual.Text = Frm.ReadTextFile(txtFileName, 50, 7);

            grpOrigins.Text = Frm.ReadTextFile(txtFileName, 50, 8);

            grpOffset.Text = Frm.ReadTextFile(txtFileName, 50, 9);
            lblOffsetX.Text = Frm.ReadTextFile(txtFileName, 50, 11);
            lblOffsetY.Text = Frm.ReadTextFile(txtFileName, 50, 12);
            lblOffsetZ.Text = Frm.ReadTextFile(txtFileName, 50, 13);

            grpGeneral.Text = Frm.ReadTextFile(txtFileName, 50, 14);
            lblDescription.Text = Frm.ReadTextFile(txtFileName, 50, 15);
            lblRevision.Text = Frm.ReadTextFile(txtFileName, 50, 16);
            lblMaterial.Text = Frm.ReadTextFile(txtFileName, 50, 17);
            lblProgrammer.Text = Frm.ReadTextFile(txtFileName, 50, 18);
            btnSettings.Text = Frm.ReadTextFile(txtFileName, 50, 19);

			Marshal.ReleaseComObject(Frm);
        }
    }
}
