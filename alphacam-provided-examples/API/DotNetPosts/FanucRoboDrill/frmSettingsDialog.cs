using AlphaCAMMill;
using System;
using System.Collections.Generic; 
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace FanucRobodrill
{
    public partial class frmSettingsDialog : Form
    {
        IAlphaCamApp Acam;
        PostData PD;
		string iniFileName;
		string txtFileName;

        public frmSettingsDialog(IAlphaCamApp Acam, PostData PD)
        {
            // Store App object in class
            this.Acam = Acam;
            this.PD = PD;

			iniFileName = FileUtils.IniFilename();
			txtFileName = FileUtils.TextFilename();

            InitializeComponent();
            ReadStringsFromTextFile();

            //Read existing values from .ini file
			IFrame Frm = Acam.Frame;
            txtOrigin_1.Text = Frm.ReadTextFile(iniFileName, 10, 1);
            txtOrigin_2.Text = Frm.ReadTextFile(iniFileName, 10, 2);
            txtOrigin_3.Text = Frm.ReadTextFile(iniFileName, 10, 3);
            txtOrigin_4.Text = Frm.ReadTextFile(iniFileName, 10, 4);
            txtOrigin_5.Text = Frm.ReadTextFile(iniFileName, 10, 5);
            txtOrigin_6.Text = Frm.ReadTextFile(iniFileName, 10, 6);

            txtOffset_1.Text = Frm.ReadTextFile(iniFileName, 20, 1);
            txtOffsetX_1.Text = Frm.ReadTextFile(iniFileName, 20, 2);
            txtOffsetY_1.Text = Frm.ReadTextFile(iniFileName, 20, 3);
            txtOffsetZ_1.Text = Frm.ReadTextFile(iniFileName, 20, 4);

            txtOffset_2.Text = Frm.ReadTextFile(iniFileName, 30, 1);
            txtOffsetX_2.Text = Frm.ReadTextFile(iniFileName, 30, 2);
            txtOffsetY_2.Text = Frm.ReadTextFile(iniFileName, 30, 3);
            txtOffsetZ_2.Text = Frm.ReadTextFile(iniFileName, 30, 4);

            txtOffset_3.Text = Frm.ReadTextFile(iniFileName, 40, 1);
            txtOffsetX_3.Text = Frm.ReadTextFile(iniFileName, 40, 2);
            txtOffsetY_3.Text = Frm.ReadTextFile(iniFileName, 40, 3);
            txtOffsetZ_3.Text = Frm.ReadTextFile(iniFileName, 40, 4);

            txtOffset_4.Text = Frm.ReadTextFile(iniFileName, 50, 1);
            txtOffsetX_4.Text = Frm.ReadTextFile(iniFileName, 50, 2);
            txtOffsetY_4.Text = Frm.ReadTextFile(iniFileName, 50, 3);
            txtOffsetZ_4.Text = Frm.ReadTextFile(iniFileName, 50, 4);

            txtOffset_0.Text = Frm.ReadTextFile(iniFileName, 60, 1);
            txtOffsetX_0.Text = Frm.ReadTextFile(iniFileName, 60, 2);
            txtOffsetY_0.Text = Frm.ReadTextFile(iniFileName, 60, 3);
            txtOffsetZ_0.Text = Frm.ReadTextFile(iniFileName, 60, 4);
            
			Marshal.ReleaseComObject(Frm);
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            // Create a string array with the lines of text
            string[] lines = {
                "$10 ''NAMES OF ORIGINS",
                txtOrigin_1.Text,
                txtOrigin_2.Text,
                txtOrigin_3.Text,
                txtOrigin_4.Text,
                txtOrigin_5.Text,
                txtOrigin_6.Text,
                " ",
                "$20 ''NAME AND VALUE OF OFFSET 1",
                txtOffset_1.Text,
                txtOffsetX_1.Text,
                txtOffsetY_1.Text,
                txtOffsetZ_1.Text,
                " ",
                "$30 ''NAME AND VALUE OF OFFSET 2",
                txtOffset_2.Text,
                txtOffsetX_2.Text,
                txtOffsetY_2.Text,
                txtOffsetZ_2.Text,
                " ",
                "$40 ''NAME AND VALUE OF OFFSET 3",
                txtOffset_3.Text,
                txtOffsetX_3.Text,
                txtOffsetY_3.Text,
                txtOffsetZ_3.Text,
                " ",
                "$50 ''NAME AND VALUE OF OFFSET 4",
                txtOffset_4.Text,
                txtOffsetX_4.Text,
                txtOffsetY_4.Text,
                txtOffsetZ_4.Text,
                " ",
                "$60 ''RESET / STARTUP VALUE FOR OFFSET",
                txtOffset_0.Text,
                txtOffsetX_0.Text,
                txtOffsetY_0.Text,
                txtOffsetZ_0.Text,
            };

            using (StreamWriter outputFile = new StreamWriter(iniFileName))
            {
                foreach (string line in lines)
                    outputFile.WriteLine(line);
            }
        }

        private void ReadStringsFromTextFile()
        {
			IFrame Frm = Acam.Frame;
            grpOriginNames.Text = Frm.ReadTextFile(txtFileName, 51, 2);
            lblPopoularNameOrigin.Text = Frm.ReadTextFile(txtFileName, 51, 3);
            lblOrigin_1.Text =  Frm.ReadTextFile(txtFileName, 51, 4);
            lblOrigin_2.Text = Frm.ReadTextFile(txtFileName, 51, 5);
            lblOrigin_3.Text = Frm.ReadTextFile(txtFileName, 51, 6);
            lblOrigin_4.Text = Frm.ReadTextFile(txtFileName, 51, 7);
            lblOrigin_5.Text = Frm.ReadTextFile(txtFileName, 51, 8);
            lblOrigin_6.Text = Frm.ReadTextFile(txtFileName, 51, 9);

            grpOffsetNames.Text = Frm.ReadTextFile(txtFileName, 51, 11);
            lblPopularNameOffset.Text = Frm.ReadTextFile(txtFileName, 51, 12);
            lblOffset_1.Text = Frm.ReadTextFile(txtFileName, 51, 13);
            lblOffset_2.Text = Frm.ReadTextFile(txtFileName, 51, 14);
            lblOffset_3.Text = Frm.ReadTextFile(txtFileName, 51, 15);
            lblOffset_4.Text = Frm.ReadTextFile(txtFileName, 51, 16);
            lblOffset_0.Text = Frm.ReadTextFile(txtFileName, 51, 17);

			Marshal.ReleaseComObject(Frm);
        }
    }
}
