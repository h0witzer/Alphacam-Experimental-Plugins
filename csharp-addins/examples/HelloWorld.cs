using System;

namespace AlphacamAddins.Examples
{
    /// <summary>
    /// Hello World Example Addin
    /// 
    /// A simple example addin that demonstrates basic structure.
    /// 
    /// Note: To use MessageBox, uncomment the Windows Forms section in the .csproj file
    /// and add 'using System.Windows.Forms;' at the top.
    /// For demonstration purposes, this example uses Console.WriteLine.
    /// </summary>
    public class HelloWorld
    {
        public void Execute()
        {
            string message = "Hello World from Alphacam C# Addin!" + Environment.NewLine + Environment.NewLine +
                           "This is a simple example to get you started." + Environment.NewLine +
                           "Check the templates folder for more complex examples.";
            
            // Using Console for cross-platform compatibility
            Console.WriteLine("=== Hello World Example ===");
            Console.WriteLine(message);
            Console.WriteLine("===========================");
            
            // Uncomment below and enable Windows Forms in .csproj to use MessageBox:
            /*
            MessageBox.Show(
                message,
                "Hello World Example",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information
            );
            */
        }
    }
}
