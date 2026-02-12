using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

// Alphacam
using AlphaCAMRouter;
using AlphaCAMMill;

namespace RunAcam__CSharp_
{
    public partial class Form1 : Form
    {
        // Acam objects
        AlphaCAMRouter.App AcamRouter;
        AlphaCAMMill.App AcamMill;

        // Global
        bool IsRouter;

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            // Initialize Alphacam Router
            AcamRouter = new AlphaCAMRouter.App();
            IsRouter = true;

            textBox1.Text = AcamRouter.AlphacamVersion.String;
        }

        private void button4_Click(object sender, EventArgs e)
        {
            // Initialize Alphacam Router
            AcamMill = new AlphaCAMMill.App();
            IsRouter = false;

            textBox2.Text = AcamMill.AlphacamVersion.String;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (IsRouter && AcamRouter != null)
            {
                AlphaCAMRouter.Drawing Drw = AcamRouter.ActiveDrawing;

                Drw.CreateRectangle(0, 0, 100, 100);
            }
            else if (!IsRouter && AcamMill != null)
            {
                AlphaCAMMill.Drawing Drw = AcamMill.ActiveDrawing;

                Drw.CreateRectangle(0, 0, 100, 100);
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (IsRouter && AcamRouter != null)
            {
                AcamRouter.Frame.RunCommand(AlphaCAMRouter.AcamCommand.acamCmdMACHINE_SELECT_TOOL);
            }
            else if (!IsRouter && AcamMill != null)
            {
                AcamMill.Frame.RunCommand(AlphaCAMMill.AcamCommand.acamCmdMACHINE_SELECT_TOOL);
            }
        }


    }
}
