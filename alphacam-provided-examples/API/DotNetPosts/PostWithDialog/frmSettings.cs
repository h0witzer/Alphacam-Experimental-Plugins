using System;
using System.Windows.Forms;

namespace PostWithDialog
{
    public partial class frmSettings : Form
    {
        public string Description { get; set; }
        public string Revision { get; set; }
        public string Material  { get; set; }
        public string Programmer { get; set; }

        public frmSettings()
        {
            InitializeComponent();
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            Description = txtDescription.Text;
            Revision = txtRevision.Text;
            Material = txtMaterial.Text;
            Programmer = txtProgrammer.Text;
        }

        private void frmSettings_Load(object sender, EventArgs e)
        {
            txtDescription.Text = Description;
            txtRevision.Text = Revision;
            txtMaterial.Text = Material;
            txtProgrammer.Text = Programmer;
        }
    }
}
