using System;
using System.IO;
using System.Linq;

using Framework.Layer.Logging;

using NUnit.Framework;

namespace Tests.Library.Framework.Layer.Tests.LoggingTests
{
    public class CustomLoggerTests
    {
        [Test]
        public void TestCustomLogger_InfoMessage_IsWritten()
        {
            const string message = "Testing method TestCustomLogger_InfoMessage_IsWritten";

            var logFilePath = Directory.EnumerateFiles(Environment.CurrentDirectory, "log.txt",
                SearchOption.AllDirectories).First();

            File.Delete(logFilePath);

            Assert.That(() => File.Exists(logFilePath), Is.False);

            var customLogger = new CustomLogger();
            customLogger.Log(msg => msg.Info(message));

            Assert.That(() => File.Exists(logFilePath), Is.True);
            Assert.True(File.ReadAllText(logFilePath).Contains(message));
        }
    }
}