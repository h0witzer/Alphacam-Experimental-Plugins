using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using ac = AlphaCAMMill;
using System.Runtime.InteropServices;

namespace CSharpPage
{
    public partial class MainPage : UserControl
    {
		private uint ID_THEME_CHANGE = 0;

		[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
		static extern uint RegisterWindowMessage(string lpString);

        public MainPage()
        {
			// Get Windows Message ID for 'AcamThemeChange'
			ID_THEME_CHANGE = RegisterWindowMessage("AcamThemeChange");
            InitializeComponent();
            InitTree();
        }

        private void btnCreateRectangle_Click(object sender, EventArgs e)
        {
            if (Main.AcamApp == null) return;

            ac.Drawing drw = Main.AcamApp.ActiveDrawing;

            double x = Convert.ToDouble(txtX.Text);
            double y = Convert.ToDouble(txtY.Text);

            drw.ScreenUpdating = false;
            ac.Path p = drw.CreateRectangle(0, 0, x, y);
            drw.ZoomAll();
            drw.ScreenUpdating = true;
        }

        private void InitTree()
        {
            treeFiles.ImageList = imageListNodes;

            string licomdir = Path.Combine(Main.AcamApp.LicomdirPath, "LICOMDIR");
            TreeNode node = treeFiles.Nodes.Add("LICOMDIR");
            PopulateTree(licomdir, node);
            node.Expand();
        }

        private void PopulateTree(string dir, TreeNode node)
        {            
            // get the information of the directory
            DirectoryInfo directory = new DirectoryInfo(dir);
            // loop through each subdirectory
            foreach (DirectoryInfo d in directory.GetDirectories())
            {
                // create a new node
                TreeNode t = new TreeNode(d.Name) 
                { 
                    ImageIndex = 0,
                    SelectedImageIndex = 0
                };

                // populate the new node recursively
                PopulateTree(d.FullName, t);
                node.Nodes.Add(t); // add the node to the "master" node
            }
            // lastly, loop through each file in the directory, and add these as nodes
            foreach (FileInfo f in directory.GetFiles("*.ard"))
            {
                // create a new node
                TreeNode t = new TreeNode(f.Name) 
                { 
                    ImageIndex = 2,
                    SelectedImageIndex = 2,
                    Tag = f.FullName
                };

                // add it to the "master"
                node.Nodes.Add(t);               
            }
        }

        private void treeFiles_NodeMouseDoubleClick(object sender, TreeNodeMouseClickEventArgs e)
        {
            string file = (string)e.Node.Tag;
            if (File.Exists(file))
            {
                Main.AcamApp.OpenDrawing(file);
            }
        }

        private void treeFiles_AfterExpand(object sender, TreeViewEventArgs e)
        {
            e.Node.ImageIndex = 1;
            e.Node.SelectedImageIndex = 1;
        }

        private void treeFiles_AfterCollapse(object sender, TreeViewEventArgs e)
        {
            e.Node.ImageIndex = 0;
            e.Node.ImageIndex = 0;
        }

		protected override void WndProc(ref Message m)
		{
			base.WndProc(ref m);

			if (m.Msg == ID_THEME_CHANGE)
			{
				// Retrieve RGB colour value for background
				int colour = (int)m.WParam;
				System.Drawing.Color clr = System.Drawing.ColorTranslator.FromWin32(colour);	
				treeFiles.BackColor = clr;
				BackColor = clr;
			}
		}
    }
}
