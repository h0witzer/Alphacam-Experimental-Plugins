namespace DoorMachiningForm
{
    partial class CathedralDoorForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.lblWidth = new System.Windows.Forms.Label();
            this.lblHeight = new System.Windows.Forms.Label();
            this.txtWidth = new System.Windows.Forms.TextBox();
            this.txtHeight = new System.Windows.Forms.TextBox();
            this.cmdOK = new System.Windows.Forms.Button();
            this.cmdCancel = new System.Windows.Forms.Button();
            this.fraPanel = new System.Windows.Forms.Panel();
            this.txtRiseHeight = new System.Windows.Forms.TextBox();
            this.lblRiseHeight = new System.Windows.Forms.Label();
            this.txtBlendRadius = new System.Windows.Forms.TextBox();
            this.lblBlendRadius = new System.Windows.Forms.Label();
            this.txtTopRadius = new System.Windows.Forms.TextBox();
            this.lblTopRadius = new System.Windows.Forms.Label();
            this.txtBorder = new System.Windows.Forms.TextBox();
            this.lblBorder = new System.Windows.Forms.Label();
            this.fraDoor = new System.Windows.Forms.Panel();
            this.txtDepth = new System.Windows.Forms.TextBox();
            this.lblDepth = new System.Windows.Forms.Label();
            this.fraPanel.SuspendLayout();
            this.fraDoor.SuspendLayout();
            this.SuspendLayout();
            // 
            // lblWidth
            // 
            this.lblWidth.AutoSize = true;
            this.lblWidth.Location = new System.Drawing.Point(20, 13);
            this.lblWidth.Name = "lblWidth";
            this.lblWidth.Size = new System.Drawing.Size(35, 13);
            this.lblWidth.TabIndex = 0;
            this.lblWidth.Text = "Width";
            // 
            // lblHeight
            // 
            this.lblHeight.AutoSize = true;
            this.lblHeight.Location = new System.Drawing.Point(20, 53);
            this.lblHeight.Name = "lblHeight";
            this.lblHeight.Size = new System.Drawing.Size(38, 13);
            this.lblHeight.TabIndex = 2;
            this.lblHeight.Text = "Height";
            // 
            // txtWidth
            // 
            this.txtWidth.Location = new System.Drawing.Point(126, 10);
            this.txtWidth.Name = "txtWidth";
            this.txtWidth.Size = new System.Drawing.Size(100, 20);
            this.txtWidth.TabIndex = 1;
            // 
            // txtHeight
            // 
            this.txtHeight.Location = new System.Drawing.Point(126, 50);
            this.txtHeight.Name = "txtHeight";
            this.txtHeight.Size = new System.Drawing.Size(100, 20);
            this.txtHeight.TabIndex = 3;
            // 
            // cmdOK
            // 
            this.cmdOK.Location = new System.Drawing.Point(152, 207);
            this.cmdOK.Name = "cmdOK";
            this.cmdOK.Size = new System.Drawing.Size(104, 32);
            this.cmdOK.TabIndex = 3;
            this.cmdOK.Text = "OK";
            this.cmdOK.UseVisualStyleBackColor = true;
            this.cmdOK.Click += new System.EventHandler(this.cmdOK_Click);
            // 
            // cmdCancel
            // 
            this.cmdCancel.Location = new System.Drawing.Point(262, 207);
            this.cmdCancel.Name = "cmdCancel";
            this.cmdCancel.Size = new System.Drawing.Size(104, 32);
            this.cmdCancel.TabIndex = 4;
            this.cmdCancel.Text = "Cancel";
            this.cmdCancel.UseVisualStyleBackColor = true;
            // 
            // fraPanel
            // 
            this.fraPanel.Controls.Add(this.txtRiseHeight);
            this.fraPanel.Controls.Add(this.lblRiseHeight);
            this.fraPanel.Controls.Add(this.txtBlendRadius);
            this.fraPanel.Controls.Add(this.lblBlendRadius);
            this.fraPanel.Controls.Add(this.txtTopRadius);
            this.fraPanel.Controls.Add(this.lblTopRadius);
            this.fraPanel.Controls.Add(this.txtBorder);
            this.fraPanel.Controls.Add(this.lblBorder);
            this.fraPanel.Location = new System.Drawing.Point(262, 12);
            this.fraPanel.Name = "fraPanel";
            this.fraPanel.Size = new System.Drawing.Size(244, 177);
            this.fraPanel.TabIndex = 2;
            // 
            // txtRiseHeight
            // 
            this.txtRiseHeight.Location = new System.Drawing.Point(126, 130);
            this.txtRiseHeight.Name = "txtRiseHeight";
            this.txtRiseHeight.Size = new System.Drawing.Size(100, 20);
            this.txtRiseHeight.TabIndex = 7;
            // 
            // lblRiseHeight
            // 
            this.lblRiseHeight.AutoSize = true;
            this.lblRiseHeight.Location = new System.Drawing.Point(20, 133);
            this.lblRiseHeight.Name = "lblRiseHeight";
            this.lblRiseHeight.Size = new System.Drawing.Size(62, 13);
            this.lblRiseHeight.TabIndex = 6;
            this.lblRiseHeight.Text = "Rise Height";
            // 
            // txtBlendRadius
            // 
            this.txtBlendRadius.Location = new System.Drawing.Point(126, 90);
            this.txtBlendRadius.Name = "txtBlendRadius";
            this.txtBlendRadius.Size = new System.Drawing.Size(100, 20);
            this.txtBlendRadius.TabIndex = 5;
            // 
            // lblBlendRadius
            // 
            this.lblBlendRadius.AutoSize = true;
            this.lblBlendRadius.Location = new System.Drawing.Point(20, 93);
            this.lblBlendRadius.Name = "lblBlendRadius";
            this.lblBlendRadius.Size = new System.Drawing.Size(70, 13);
            this.lblBlendRadius.TabIndex = 4;
            this.lblBlendRadius.Text = "Blend Radius";
            // 
            // txtTopRadius
            // 
            this.txtTopRadius.Location = new System.Drawing.Point(126, 50);
            this.txtTopRadius.Name = "txtTopRadius";
            this.txtTopRadius.Size = new System.Drawing.Size(100, 20);
            this.txtTopRadius.TabIndex = 3;
            // 
            // lblTopRadius
            // 
            this.lblTopRadius.AutoSize = true;
            this.lblTopRadius.Location = new System.Drawing.Point(20, 53);
            this.lblTopRadius.Name = "lblTopRadius";
            this.lblTopRadius.Size = new System.Drawing.Size(62, 13);
            this.lblTopRadius.TabIndex = 2;
            this.lblTopRadius.Text = "Top Radius";
            // 
            // txtBorder
            // 
            this.txtBorder.Location = new System.Drawing.Point(126, 10);
            this.txtBorder.Name = "txtBorder";
            this.txtBorder.Size = new System.Drawing.Size(100, 20);
            this.txtBorder.TabIndex = 1;
            // 
            // lblBorder
            // 
            this.lblBorder.AutoSize = true;
            this.lblBorder.Location = new System.Drawing.Point(20, 13);
            this.lblBorder.Name = "lblBorder";
            this.lblBorder.Size = new System.Drawing.Size(38, 13);
            this.lblBorder.TabIndex = 0;
            this.lblBorder.Text = "Border";
            // 
            // fraDoor
            // 
            this.fraDoor.Controls.Add(this.txtDepth);
            this.fraDoor.Controls.Add(this.lblDepth);
            this.fraDoor.Controls.Add(this.lblWidth);
            this.fraDoor.Controls.Add(this.lblHeight);
            this.fraDoor.Controls.Add(this.txtWidth);
            this.fraDoor.Controls.Add(this.txtHeight);
            this.fraDoor.Location = new System.Drawing.Point(12, 12);
            this.fraDoor.Name = "fraDoor";
            this.fraDoor.Size = new System.Drawing.Size(244, 177);
            this.fraDoor.TabIndex = 1;
            // 
            // txtDepth
            // 
            this.txtDepth.Location = new System.Drawing.Point(126, 90);
            this.txtDepth.Name = "txtDepth";
            this.txtDepth.Size = new System.Drawing.Size(100, 20);
            this.txtDepth.TabIndex = 5;
            // 
            // lblDepth
            // 
            this.lblDepth.AutoSize = true;
            this.lblDepth.Location = new System.Drawing.Point(20, 93);
            this.lblDepth.Name = "lblDepth";
            this.lblDepth.Size = new System.Drawing.Size(36, 13);
            this.lblDepth.TabIndex = 4;
            this.lblDepth.Text = "Depth";
            // 
            // CathedralDoorForm
            // 
            this.AllowDrop = true;
            this.ClientSize = new System.Drawing.Size(519, 250);
            this.Controls.Add(this.fraDoor);
            this.Controls.Add(this.fraPanel);
            this.Controls.Add(this.cmdCancel);
            this.Controls.Add(this.cmdOK);
            this.Name = "CathedralDoorForm";
            this.Text = "Cathedral Door";
            this.Load += new System.EventHandler(this.CathedralDoorForm_Load);
            this.fraPanel.ResumeLayout(false);
            this.fraPanel.PerformLayout();
            this.fraDoor.ResumeLayout(false);
            this.fraDoor.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label lblWidth;
        private System.Windows.Forms.Label lblHeight;
        private System.Windows.Forms.TextBox txtWidth;
        private System.Windows.Forms.TextBox txtHeight;
        private System.Windows.Forms.Button cmdOK;
        private System.Windows.Forms.Button cmdCancel;
        private System.Windows.Forms.Panel fraPanel;
        private System.Windows.Forms.Panel fraDoor;
        private System.Windows.Forms.TextBox txtDepth;
        private System.Windows.Forms.Label lblDepth;
        private System.Windows.Forms.TextBox txtRiseHeight;
        private System.Windows.Forms.Label lblRiseHeight;
        private System.Windows.Forms.TextBox txtBlendRadius;
        private System.Windows.Forms.Label lblBlendRadius;
        private System.Windows.Forms.TextBox txtTopRadius;
        private System.Windows.Forms.Label lblTopRadius;
        private System.Windows.Forms.TextBox txtBorder;
        private System.Windows.Forms.Label lblBorder;
    }
}