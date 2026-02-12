namespace FanucRobodrill
{
	partial class frmPostDialog
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
			this.txtDescription = new System.Windows.Forms.TextBox();
			this.lblDescription = new System.Windows.Forms.Label();
			this.lblRevision = new System.Windows.Forms.Label();
			this.txtRevision = new System.Windows.Forms.TextBox();
			this.lblMaterial = new System.Windows.Forms.Label();
			this.txtMaterial = new System.Windows.Forms.TextBox();
			this.lblProgrammer = new System.Windows.Forms.Label();
			this.txtProgrammer = new System.Windows.Forms.TextBox();
			this.btnOK = new System.Windows.Forms.Button();
			this.btnCancel = new System.Windows.Forms.Button();
			this.lblLength = new System.Windows.Forms.Label();
			this.txtLength = new System.Windows.Forms.TextBox();
			this.lblWidth = new System.Windows.Forms.Label();
			this.txtWidth = new System.Windows.Forms.TextBox();
			this.lblThickness = new System.Windows.Forms.Label();
			this.txtThickness = new System.Windows.Forms.TextBox();
			this.optWorkVolume = new System.Windows.Forms.RadioButton();
			this.optMaterial = new System.Windows.Forms.RadioButton();
			this.optManual = new System.Windows.Forms.RadioButton();
			this.grpPanelSize = new System.Windows.Forms.GroupBox();
			this.grpGeneral = new System.Windows.Forms.GroupBox();
			this.grpOrigins = new System.Windows.Forms.GroupBox();
			this.optOrigin_6 = new System.Windows.Forms.RadioButton();
			this.optOrigin_5 = new System.Windows.Forms.RadioButton();
			this.optOrigin_4 = new System.Windows.Forms.RadioButton();
			this.optOrigin_3 = new System.Windows.Forms.RadioButton();
			this.optOrigin_2 = new System.Windows.Forms.RadioButton();
			this.optOrigin_1 = new System.Windows.Forms.RadioButton();
			this.grpOffset = new System.Windows.Forms.GroupBox();
			this.lblOffsetX = new System.Windows.Forms.Label();
			this.lblOffsetZ = new System.Windows.Forms.Label();
			this.lblOffsetY = new System.Windows.Forms.Label();
			this.btnReset = new System.Windows.Forms.Button();
			this.btnDefault4 = new System.Windows.Forms.Button();
			this.btnDefault3 = new System.Windows.Forms.Button();
			this.btnDefault2 = new System.Windows.Forms.Button();
			this.btnDefault1 = new System.Windows.Forms.Button();
			this.txtOffsetX = new System.Windows.Forms.TextBox();
			this.txtOffsetY = new System.Windows.Forms.TextBox();
			this.txtOffsetZ = new System.Windows.Forms.TextBox();
			this.btnSettings = new System.Windows.Forms.Button();
			this.pictureBox1 = new System.Windows.Forms.PictureBox();
			this.grpPanelSize.SuspendLayout();
			this.grpGeneral.SuspendLayout();
			this.grpOrigins.SuspendLayout();
			this.grpOffset.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
			this.SuspendLayout();
			// 
			// txtDescription
			// 
			this.txtDescription.Location = new System.Drawing.Point(97, 34);
			this.txtDescription.Name = "txtDescription";
			this.txtDescription.Size = new System.Drawing.Size(178, 20);
			this.txtDescription.TabIndex = 0;
			// 
			// lblDescription
			// 
			this.lblDescription.AutoSize = true;
			this.lblDescription.Location = new System.Drawing.Point(19, 36);
			this.lblDescription.Name = "lblDescription";
			this.lblDescription.Size = new System.Drawing.Size(60, 13);
			this.lblDescription.TabIndex = 1;
			this.lblDescription.Text = "Description";
			// 
			// lblRevision
			// 
			this.lblRevision.AutoSize = true;
			this.lblRevision.Location = new System.Drawing.Point(19, 69);
			this.lblRevision.Name = "lblRevision";
			this.lblRevision.Size = new System.Drawing.Size(48, 13);
			this.lblRevision.TabIndex = 3;
			this.lblRevision.Text = "Revision";
			// 
			// txtRevision
			// 
			this.txtRevision.Location = new System.Drawing.Point(97, 67);
			this.txtRevision.Name = "txtRevision";
			this.txtRevision.Size = new System.Drawing.Size(178, 20);
			this.txtRevision.TabIndex = 2;
			// 
			// lblMaterial
			// 
			this.lblMaterial.AutoSize = true;
			this.lblMaterial.Location = new System.Drawing.Point(19, 102);
			this.lblMaterial.Name = "lblMaterial";
			this.lblMaterial.Size = new System.Drawing.Size(44, 13);
			this.lblMaterial.TabIndex = 5;
			this.lblMaterial.Text = "Material";
			// 
			// txtMaterial
			// 
			this.txtMaterial.Location = new System.Drawing.Point(97, 100);
			this.txtMaterial.Name = "txtMaterial";
			this.txtMaterial.Size = new System.Drawing.Size(178, 20);
			this.txtMaterial.TabIndex = 4;
			// 
			// lblProgrammer
			// 
			this.lblProgrammer.AutoSize = true;
			this.lblProgrammer.Location = new System.Drawing.Point(19, 135);
			this.lblProgrammer.Name = "lblProgrammer";
			this.lblProgrammer.Size = new System.Drawing.Size(63, 13);
			this.lblProgrammer.TabIndex = 7;
			this.lblProgrammer.Text = "Programmer";
			// 
			// txtProgrammer
			// 
			this.txtProgrammer.Location = new System.Drawing.Point(97, 133);
			this.txtProgrammer.Name = "txtProgrammer";
			this.txtProgrammer.Size = new System.Drawing.Size(178, 20);
			this.txtProgrammer.TabIndex = 6;
			// 
			// btnOK
			// 
			this.btnOK.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.btnOK.Location = new System.Drawing.Point(189, 479);
			this.btnOK.Name = "btnOK";
			this.btnOK.Size = new System.Drawing.Size(99, 27);
			this.btnOK.TabIndex = 8;
			this.btnOK.Text = "OK";
			this.btnOK.UseVisualStyleBackColor = true;
			this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
			// 
			// btnCancel
			// 
			this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.btnCancel.Location = new System.Drawing.Point(321, 479);
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.Size = new System.Drawing.Size(99, 27);
			this.btnCancel.TabIndex = 9;
			this.btnCancel.Text = "Cancel";
			this.btnCancel.UseVisualStyleBackColor = true;
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// lblLength
			// 
			this.lblLength.AutoSize = true;
			this.lblLength.Location = new System.Drawing.Point(125, 37);
			this.lblLength.Name = "lblLength";
			this.lblLength.Size = new System.Drawing.Size(40, 13);
			this.lblLength.TabIndex = 12;
			this.lblLength.Text = "Length";
			// 
			// txtLength
			// 
			this.txtLength.Location = new System.Drawing.Point(181, 33);
			this.txtLength.Name = "txtLength";
			this.txtLength.Size = new System.Drawing.Size(62, 20);
			this.txtLength.TabIndex = 11;
			// 
			// lblWidth
			// 
			this.lblWidth.AutoSize = true;
			this.lblWidth.Location = new System.Drawing.Point(125, 71);
			this.lblWidth.Name = "lblWidth";
			this.lblWidth.Size = new System.Drawing.Size(35, 13);
			this.lblWidth.TabIndex = 14;
			this.lblWidth.Text = "Width";
			// 
			// txtWidth
			// 
			this.txtWidth.Location = new System.Drawing.Point(181, 67);
			this.txtWidth.Name = "txtWidth";
			this.txtWidth.Size = new System.Drawing.Size(62, 20);
			this.txtWidth.TabIndex = 13;
			// 
			// lblThickness
			// 
			this.lblThickness.AutoSize = true;
			this.lblThickness.Location = new System.Drawing.Point(125, 104);
			this.lblThickness.Name = "lblThickness";
			this.lblThickness.Size = new System.Drawing.Size(56, 13);
			this.lblThickness.TabIndex = 16;
			this.lblThickness.Text = "Thickness";
			// 
			// txtThickness
			// 
			this.txtThickness.Location = new System.Drawing.Point(181, 100);
			this.txtThickness.Name = "txtThickness";
			this.txtThickness.Size = new System.Drawing.Size(62, 20);
			this.txtThickness.TabIndex = 15;
			// 
			// optWorkVolume
			// 
			this.optWorkVolume.AutoSize = true;
			this.optWorkVolume.Location = new System.Drawing.Point(18, 35);
			this.optWorkVolume.Name = "optWorkVolume";
			this.optWorkVolume.Size = new System.Drawing.Size(86, 17);
			this.optWorkVolume.TabIndex = 18;
			this.optWorkVolume.TabStop = true;
			this.optWorkVolume.Text = "WorkVolume";
			this.optWorkVolume.UseVisualStyleBackColor = true;
			this.optWorkVolume.CheckedChanged += new System.EventHandler(this.optWorkVolume_CheckedChanged);
			// 
			// optMaterial
			// 
			this.optMaterial.AutoSize = true;
			this.optMaterial.Location = new System.Drawing.Point(18, 69);
			this.optMaterial.Name = "optMaterial";
			this.optMaterial.Size = new System.Drawing.Size(62, 17);
			this.optMaterial.TabIndex = 19;
			this.optMaterial.TabStop = true;
			this.optMaterial.Text = "Material";
			this.optMaterial.UseVisualStyleBackColor = true;
			this.optMaterial.CheckedChanged += new System.EventHandler(this.optMaterial_CheckedChanged);
			// 
			// optManual
			// 
			this.optManual.AutoSize = true;
			this.optManual.Location = new System.Drawing.Point(18, 102);
			this.optManual.Name = "optManual";
			this.optManual.Size = new System.Drawing.Size(60, 17);
			this.optManual.TabIndex = 20;
			this.optManual.TabStop = true;
			this.optManual.Text = "Manual";
			this.optManual.UseVisualStyleBackColor = true;
			this.optManual.CheckedChanged += new System.EventHandler(this.optManual_CheckedChanged);
			// 
			// grpPanelSize
			// 
			this.grpPanelSize.Controls.Add(this.optWorkVolume);
			this.grpPanelSize.Controls.Add(this.optManual);
			this.grpPanelSize.Controls.Add(this.txtLength);
			this.grpPanelSize.Controls.Add(this.optMaterial);
			this.grpPanelSize.Controls.Add(this.lblLength);
			this.grpPanelSize.Controls.Add(this.txtWidth);
			this.grpPanelSize.Controls.Add(this.lblThickness);
			this.grpPanelSize.Controls.Add(this.lblWidth);
			this.grpPanelSize.Controls.Add(this.txtThickness);
			this.grpPanelSize.Location = new System.Drawing.Point(12, 101);
			this.grpPanelSize.Name = "grpPanelSize";
			this.grpPanelSize.Size = new System.Drawing.Size(276, 166);
			this.grpPanelSize.TabIndex = 21;
			this.grpPanelSize.TabStop = false;
			this.grpPanelSize.Text = "Panel Size, Select Method";
			// 
			// grpGeneral
			// 
			this.grpGeneral.Controls.Add(this.txtDescription);
			this.grpGeneral.Controls.Add(this.lblDescription);
			this.grpGeneral.Controls.Add(this.txtRevision);
			this.grpGeneral.Controls.Add(this.lblRevision);
			this.grpGeneral.Controls.Add(this.txtMaterial);
			this.grpGeneral.Controls.Add(this.lblProgrammer);
			this.grpGeneral.Controls.Add(this.lblMaterial);
			this.grpGeneral.Controls.Add(this.txtProgrammer);
			this.grpGeneral.Location = new System.Drawing.Point(301, 101);
			this.grpGeneral.Name = "grpGeneral";
			this.grpGeneral.Size = new System.Drawing.Size(297, 166);
			this.grpGeneral.TabIndex = 22;
			this.grpGeneral.TabStop = false;
			this.grpGeneral.Text = "General Information";
			// 
			// grpOrigins
			// 
			this.grpOrigins.Controls.Add(this.optOrigin_6);
			this.grpOrigins.Controls.Add(this.optOrigin_5);
			this.grpOrigins.Controls.Add(this.optOrigin_4);
			this.grpOrigins.Controls.Add(this.optOrigin_3);
			this.grpOrigins.Controls.Add(this.optOrigin_2);
			this.grpOrigins.Controls.Add(this.optOrigin_1);
			this.grpOrigins.Location = new System.Drawing.Point(12, 273);
			this.grpOrigins.Name = "grpOrigins";
			this.grpOrigins.Size = new System.Drawing.Size(276, 174);
			this.grpOrigins.TabIndex = 23;
			this.grpOrigins.TabStop = false;
			this.grpOrigins.Text = "Origins";
			// 
			// optOrigin_6
			// 
			this.optOrigin_6.AutoSize = true;
			this.optOrigin_6.Location = new System.Drawing.Point(18, 148);
			this.optOrigin_6.Name = "optOrigin_6";
			this.optOrigin_6.Size = new System.Drawing.Size(45, 17);
			this.optOrigin_6.TabIndex = 24;
			this.optOrigin_6.TabStop = true;
			this.optOrigin_6.Text = "G59";
			this.optOrigin_6.UseVisualStyleBackColor = true;
			this.optOrigin_6.CheckedChanged += new System.EventHandler(this.optOrigin_6_CheckedChanged);
			// 
			// optOrigin_5
			// 
			this.optOrigin_5.AutoSize = true;
			this.optOrigin_5.Location = new System.Drawing.Point(18, 125);
			this.optOrigin_5.Name = "optOrigin_5";
			this.optOrigin_5.Size = new System.Drawing.Size(45, 17);
			this.optOrigin_5.TabIndex = 23;
			this.optOrigin_5.TabStop = true;
			this.optOrigin_5.Text = "G58";
			this.optOrigin_5.UseVisualStyleBackColor = true;
			this.optOrigin_5.CheckedChanged += new System.EventHandler(this.optOrigin_5_CheckedChanged);
			// 
			// optOrigin_4
			// 
			this.optOrigin_4.AutoSize = true;
			this.optOrigin_4.Location = new System.Drawing.Point(18, 102);
			this.optOrigin_4.Name = "optOrigin_4";
			this.optOrigin_4.Size = new System.Drawing.Size(45, 17);
			this.optOrigin_4.TabIndex = 22;
			this.optOrigin_4.TabStop = true;
			this.optOrigin_4.Text = "G57";
			this.optOrigin_4.UseVisualStyleBackColor = true;
			this.optOrigin_4.CheckedChanged += new System.EventHandler(this.optOrigin_4_CheckedChanged);
			// 
			// optOrigin_3
			// 
			this.optOrigin_3.AutoSize = true;
			this.optOrigin_3.Location = new System.Drawing.Point(18, 79);
			this.optOrigin_3.Name = "optOrigin_3";
			this.optOrigin_3.Size = new System.Drawing.Size(45, 17);
			this.optOrigin_3.TabIndex = 21;
			this.optOrigin_3.TabStop = true;
			this.optOrigin_3.Text = "G56";
			this.optOrigin_3.UseVisualStyleBackColor = true;
			this.optOrigin_3.CheckedChanged += new System.EventHandler(this.optOrigin_3_CheckedChanged);
			// 
			// optOrigin_2
			// 
			this.optOrigin_2.AutoSize = true;
			this.optOrigin_2.Location = new System.Drawing.Point(18, 56);
			this.optOrigin_2.Name = "optOrigin_2";
			this.optOrigin_2.Size = new System.Drawing.Size(45, 17);
			this.optOrigin_2.TabIndex = 20;
			this.optOrigin_2.TabStop = true;
			this.optOrigin_2.Text = "G55";
			this.optOrigin_2.UseVisualStyleBackColor = true;
			this.optOrigin_2.CheckedChanged += new System.EventHandler(this.optOrigin_2_CheckedChanged);
			// 
			// optOrigin_1
			// 
			this.optOrigin_1.AutoSize = true;
			this.optOrigin_1.Location = new System.Drawing.Point(18, 33);
			this.optOrigin_1.Name = "optOrigin_1";
			this.optOrigin_1.Size = new System.Drawing.Size(45, 17);
			this.optOrigin_1.TabIndex = 19;
			this.optOrigin_1.TabStop = true;
			this.optOrigin_1.Text = "G54";
			this.optOrigin_1.UseVisualStyleBackColor = true;
			this.optOrigin_1.CheckedChanged += new System.EventHandler(this.optOrigin_1_CheckedChanged);
			// 
			// grpOffset
			// 
			this.grpOffset.Controls.Add(this.lblOffsetX);
			this.grpOffset.Controls.Add(this.lblOffsetZ);
			this.grpOffset.Controls.Add(this.lblOffsetY);
			this.grpOffset.Controls.Add(this.btnReset);
			this.grpOffset.Controls.Add(this.btnDefault4);
			this.grpOffset.Controls.Add(this.btnDefault3);
			this.grpOffset.Controls.Add(this.btnDefault2);
			this.grpOffset.Controls.Add(this.btnDefault1);
			this.grpOffset.Controls.Add(this.txtOffsetX);
			this.grpOffset.Controls.Add(this.txtOffsetY);
			this.grpOffset.Controls.Add(this.txtOffsetZ);
			this.grpOffset.Location = new System.Drawing.Point(302, 273);
			this.grpOffset.Name = "grpOffset";
			this.grpOffset.Size = new System.Drawing.Size(296, 174);
			this.grpOffset.TabIndex = 24;
			this.grpOffset.TabStop = false;
			this.grpOffset.Text = "Offset from Origin";
			// 
			// lblOffsetX
			// 
			this.lblOffsetX.AutoSize = true;
			this.lblOffsetX.Location = new System.Drawing.Point(144, 35);
			this.lblOffsetX.Name = "lblOffsetX";
			this.lblOffsetX.Size = new System.Drawing.Size(56, 13);
			this.lblOffsetX.TabIndex = 28;
			this.lblOffsetX.Text = "Offset in X";
			// 
			// lblOffsetZ
			// 
			this.lblOffsetZ.AutoSize = true;
			this.lblOffsetZ.Location = new System.Drawing.Point(144, 102);
			this.lblOffsetZ.Name = "lblOffsetZ";
			this.lblOffsetZ.Size = new System.Drawing.Size(56, 13);
			this.lblOffsetZ.TabIndex = 30;
			this.lblOffsetZ.Text = "Offset in Z";
			// 
			// lblOffsetY
			// 
			this.lblOffsetY.AutoSize = true;
			this.lblOffsetY.Location = new System.Drawing.Point(144, 69);
			this.lblOffsetY.Name = "lblOffsetY";
			this.lblOffsetY.Size = new System.Drawing.Size(56, 13);
			this.lblOffsetY.TabIndex = 29;
			this.lblOffsetY.Text = "Offset in Y";
			// 
			// btnReset
			// 
			this.btnReset.Location = new System.Drawing.Point(161, 133);
			this.btnReset.Name = "btnReset";
			this.btnReset.Size = new System.Drawing.Size(113, 22);
			this.btnReset.TabIndex = 27;
			this.btnReset.Text = "Reset Offset";
			this.btnReset.UseVisualStyleBackColor = true;
			this.btnReset.Click += new System.EventHandler(this.button1_Click);
			// 
			// btnDefault4
			// 
			this.btnDefault4.Location = new System.Drawing.Point(6, 133);
			this.btnDefault4.Name = "btnDefault4";
			this.btnDefault4.Size = new System.Drawing.Size(113, 22);
			this.btnDefault4.TabIndex = 26;
			this.btnDefault4.Text = "Default 4";
			this.btnDefault4.UseVisualStyleBackColor = true;
			this.btnDefault4.Click += new System.EventHandler(this.btnDefault4_Click);
			// 
			// btnDefault3
			// 
			this.btnDefault3.Location = new System.Drawing.Point(6, 99);
			this.btnDefault3.Name = "btnDefault3";
			this.btnDefault3.Size = new System.Drawing.Size(113, 22);
			this.btnDefault3.TabIndex = 25;
			this.btnDefault3.Text = "Default 3";
			this.btnDefault3.UseVisualStyleBackColor = true;
			this.btnDefault3.Click += new System.EventHandler(this.btnDefault3_Click);
			// 
			// btnDefault2
			// 
			this.btnDefault2.Location = new System.Drawing.Point(6, 66);
			this.btnDefault2.Name = "btnDefault2";
			this.btnDefault2.Size = new System.Drawing.Size(113, 22);
			this.btnDefault2.TabIndex = 24;
			this.btnDefault2.Text = "Default 2";
			this.btnDefault2.UseVisualStyleBackColor = true;
			this.btnDefault2.Click += new System.EventHandler(this.btnDefault2_Click);
			// 
			// btnDefault1
			// 
			this.btnDefault1.Location = new System.Drawing.Point(6, 32);
			this.btnDefault1.Name = "btnDefault1";
			this.btnDefault1.Size = new System.Drawing.Size(113, 22);
			this.btnDefault1.TabIndex = 23;
			this.btnDefault1.Text = "Default 1";
			this.btnDefault1.UseVisualStyleBackColor = true;
			this.btnDefault1.Click += new System.EventHandler(this.btnDefault1_Click);
			// 
			// txtOffsetX
			// 
			this.txtOffsetX.Location = new System.Drawing.Point(206, 32);
			this.txtOffsetX.Name = "txtOffsetX";
			this.txtOffsetX.Size = new System.Drawing.Size(68, 20);
			this.txtOffsetX.TabIndex = 17;
			// 
			// txtOffsetY
			// 
			this.txtOffsetY.Location = new System.Drawing.Point(206, 66);
			this.txtOffsetY.Name = "txtOffsetY";
			this.txtOffsetY.Size = new System.Drawing.Size(68, 20);
			this.txtOffsetY.TabIndex = 19;
			// 
			// txtOffsetZ
			// 
			this.txtOffsetZ.Location = new System.Drawing.Point(206, 99);
			this.txtOffsetZ.Name = "txtOffsetZ";
			this.txtOffsetZ.Size = new System.Drawing.Size(68, 20);
			this.txtOffsetZ.TabIndex = 21;
			// 
			// btnSettings
			// 
			this.btnSettings.Location = new System.Drawing.Point(463, 479);
			this.btnSettings.Name = "btnSettings";
			this.btnSettings.Size = new System.Drawing.Size(113, 28);
			this.btnSettings.TabIndex = 25;
			this.btnSettings.Text = "Settings";
			this.btnSettings.UseVisualStyleBackColor = true;
			this.btnSettings.Click += new System.EventHandler(this.btnSettings_Click);
			// 
			// pictureBox1
			// 
			this.pictureBox1.Image = global::FanucRobodrill.Properties.Resources.Alphacam_Logo;
			this.pictureBox1.Location = new System.Drawing.Point(19, 12);
			this.pictureBox1.Name = "pictureBox1";
			this.pictureBox1.Size = new System.Drawing.Size(269, 69);
			this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
			this.pictureBox1.TabIndex = 10;
			this.pictureBox1.TabStop = false;
			// 
			// frmPostDialog
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(608, 519);
			this.Controls.Add(this.btnSettings);
			this.Controls.Add(this.grpOffset);
			this.Controls.Add(this.grpOrigins);
			this.Controls.Add(this.grpGeneral);
			this.Controls.Add(this.grpPanelSize);
			this.Controls.Add(this.pictureBox1);
			this.Controls.Add(this.btnCancel);
			this.Controls.Add(this.btnOK);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "frmPostDialog";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "C# Post Settings";
			this.Load += new System.EventHandler(this.frmSettings_Load);
			this.grpPanelSize.ResumeLayout(false);
			this.grpPanelSize.PerformLayout();
			this.grpGeneral.ResumeLayout(false);
			this.grpGeneral.PerformLayout();
			this.grpOrigins.ResumeLayout(false);
			this.grpOrigins.PerformLayout();
			this.grpOffset.ResumeLayout(false);
			this.grpOffset.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.TextBox txtDescription;
		private System.Windows.Forms.Label lblDescription;
		private System.Windows.Forms.Label lblRevision;
		private System.Windows.Forms.TextBox txtRevision;
		private System.Windows.Forms.Label lblMaterial;
		private System.Windows.Forms.TextBox txtMaterial;
		private System.Windows.Forms.Label lblProgrammer;
		private System.Windows.Forms.TextBox txtProgrammer;
		private System.Windows.Forms.Button btnOK;
		private System.Windows.Forms.Button btnCancel;
		private System.Windows.Forms.PictureBox pictureBox1;
		private System.Windows.Forms.Label lblLength;
		private System.Windows.Forms.TextBox txtLength;
		private System.Windows.Forms.Label lblWidth;
		private System.Windows.Forms.TextBox txtWidth;
		private System.Windows.Forms.Label lblThickness;
		private System.Windows.Forms.TextBox txtThickness;
		private System.Windows.Forms.RadioButton optWorkVolume;
		private System.Windows.Forms.RadioButton optMaterial;
		private System.Windows.Forms.RadioButton optManual;
		private System.Windows.Forms.GroupBox grpPanelSize;
		private System.Windows.Forms.GroupBox grpGeneral;
		private System.Windows.Forms.GroupBox grpOrigins;
		private System.Windows.Forms.RadioButton optOrigin_1;
		private System.Windows.Forms.RadioButton optOrigin_6;
		private System.Windows.Forms.RadioButton optOrigin_5;
		private System.Windows.Forms.RadioButton optOrigin_4;
		private System.Windows.Forms.RadioButton optOrigin_3;
		private System.Windows.Forms.RadioButton optOrigin_2;
		private System.Windows.Forms.GroupBox grpOffset;
		private System.Windows.Forms.Button btnDefault1;
		private System.Windows.Forms.Button btnDefault4;
		private System.Windows.Forms.Button btnDefault3;
		private System.Windows.Forms.Button btnDefault2;
		private System.Windows.Forms.Button btnReset;
		private System.Windows.Forms.TextBox txtOffsetX;
		private System.Windows.Forms.TextBox txtOffsetY;
		private System.Windows.Forms.TextBox txtOffsetZ;
		private System.Windows.Forms.Label lblOffsetX;
		private System.Windows.Forms.Label lblOffsetZ;
		private System.Windows.Forms.Label lblOffsetY;
		private System.Windows.Forms.Button btnSettings;
	}
}