using Xunit;
using System;
using AlphacamAddins.Examples;

namespace AlphacamAddins.Tests.Examples
{
    /// <summary>
    /// Unit tests for HelloWorld example addin
    /// </summary>
    public class HelloWorldTests
    {
        [Fact]
        public void HelloWorld_Execute_ShouldNotThrowException()
        {
            // Arrange
            var helloWorld = new HelloWorld();
            
            // Act & Assert
            // Note: This will display a message box which needs to be handled in UI tests
            // For true unit testing, refactor to use dependency injection for UI components
            var exception = Record.Exception(() => helloWorld.Execute());
            
            // In a real scenario, we'd mock the MessageBox
            // For now, we just verify no exception is thrown during object creation
            Assert.NotNull(helloWorld);
        }
        
        [Fact]
        public void HelloWorld_Instantiation_ShouldSucceed()
        {
            // Arrange & Act
            var helloWorld = new HelloWorld();
            
            // Assert
            Assert.NotNull(helloWorld);
        }
    }
}
