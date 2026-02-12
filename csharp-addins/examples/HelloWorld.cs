using System;
using System.Windows.Forms;

namespace AlphacamAddins.Examples
{
    /// <summary>
    /// Hello World Example Addin
    /// 
    /// A simple example addin that demonstrates basic structure
    /// and message display in Alphacam.
    /// </summary>
    public class HelloWorld
    {
        public void Execute()
        {
            string message = "Hello World from Alphacam C# Addin!\n\n" +
                           "This is a simple example to get you started.\n" +
                           "Check the templates folder for more complex examples.";
            
            MessageBox.Show(
                message,
                "Hello World Example",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information
            );
        }
    }
}
