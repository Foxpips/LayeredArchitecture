using System;
using System.IO;
using System.Linq;

using Business.Logic.Layer.Interfaces.Logging;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

using StructureMap;

namespace Tests.Unit.Framework.Layer.Tests.LoggingTests
{
    public class CustomLoggerTests
    {
        private ICustomLogger _customLogger;

        [SetUp]
        public void Setup()
        {
            DependencyManager.ConfigureStartupDependencies();

            _customLogger = ObjectFactory.Container.GetInstance<ICustomLogger>();
        }

        [Test]
        public void TestCustomLogger_InfoMessage_IsWritten()
        {
            const string message = "Testing method TestCustomLogger_InfoMessage_IsWritten";

            var logFilePath = Directory.EnumerateFiles(Environment.CurrentDirectory, "log.txt",
                SearchOption.AllDirectories).First();

            File.Delete(logFilePath);

            Assert.That(() => File.Exists(logFilePath), Is.False);

            _customLogger.Info(message);

            Assert.That(() => File.Exists(logFilePath), Is.True);
            Assert.True(File.ReadAllText(logFilePath).Contains(message));
        }
    }
}