using System;
using System.Windows.Forms;
using AlphaCAMMill;
using DoorMachiningAddin;

namespace DoorMachiningForm
{
    public partial class CathedralDoorForm : Form
    {
        IAlphaCamApp Acam;
        public CathedralDoorForm(IAlphaCamApp AcamApp)
        {
            Acam = AcamApp;
            InitializeComponent();
        }

        private void cmdOK_Click(object sender, EventArgs e)
        {
            this.Hide();
            Main CDMain = new Main(Acam);
            CDMain.CreateCathedralDoor(Convert.ToDouble(txtHeight.Text), Convert.ToDouble(txtWidth.Text), Convert.ToDouble(txtDepth.Text),
               Convert.ToDouble(txtBorder.Text), Convert.ToDouble(txtRiseHeight.Text), Convert.ToDouble(txtBlendRadius.Text), Convert.ToDouble(txtTopRadius.Text));
        }

        private void CathedralDoorForm_Load(object sender, EventArgs e)
        {
            if(txtWidth.TextLength == 0)
            {
                // set defaults for door
                txtWidth.Text = "500";
                txtHeight.Text = "800";
                txtDepth.Text = "18";

                // set defaults for panel
                txtBorder.Text = "50";
                txtTopRadius.Text = "175";
                txtBlendRadius.Text = "50";
                txtRiseHeight.Text = "100";
            }
            txtWidth.Focus();
            txtWidth.SelectionStart = 0;
            txtWidth.SelectionLength = 999;
        }
    }
}
