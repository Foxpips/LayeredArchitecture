using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;

using Business.Logic.Layer.Pocos.Sql;

using Core.Library.Helpers;

using Dependency.Resolver.Loaders;

using NUnit.Framework;

using Service.Layer.ScriptRunnerService.Runner;
using Service.Layer.ScriptRunnerService.SqlManagers;

using SqlAgentUIRunner.Controllers;

using StructureMap;

namespace Tests.Integration.ScriptRunnerServiceTests
{
    [TestFixture]
    internal sealed class SqlCoreTests
    {
        private string _connectionString;
        private string _rootdirString;
        public string BackupsOutputDirectory { get; set; }
        public string ComparisonOutputDirectory { get; set; }
        public JsonHelper JsonHelper { get; set; }

        [SetUp]
        public void Setup()
        {
            new DependencyManager(ObjectFactory.Container).ConfigureStartupDependencies();
            _connectionString =
                JsonHelper.DeserializeJsonFromFile<SqlServerCredentials>(@"..\..\..\Miscellaneous\Json\Servers.json")
                    .ConnectionString;
            _rootdirString = @"../../../Miscellaneous\StoredProcedures\";
            BackupsOutputDirectory = @"..\..\..\Miscellaneous\StoredProcedures\Backup_" +
                                     DateTime.Now.ToString("yyyy MMMM dd");
            ComparisonOutputDirectory = @"..\..\..\Miscellaneous\StoredProcedures\Comparisons\";
        }

        [Test]
        public void BackupSprocs_CheckIfProcsAreBackedup_AFileContainingSprocsContents()
        {
            const string sprocName = "b4nCheckProcsExist";
            SqlManager.BackupSproc(_connectionString, sprocName);

            string path = _rootdirString + @"\Backup_" + DateTime.Now.ToString("yyyy MMMM dd");
            IEnumerable<string> lines = File.ReadLines(path + @"\b4nCheckProcsExist.sql");
            Assert.That(lines.Any(x => x.Contains("b4nCheckProcsExist")));
        }

        [Test]
        public void BackupSprocs_CheckAllSprocsBackedUp_AllDbSprocsCopiedLocally()
        {
            IEnumerable<string> sprocsInDatabaseList = SqlManager.GetSprocs_InDatabase_List(_connectionString);

            Assert.IsTrue(sprocsInDatabaseList.Any());

            var backupController = new BackupController();

            backupController.Backup(
                _connectionString);

            while (BackupController.UpdateTaskManager.TasksInProgress())
            {
                Thread.Sleep(TimeSpan.FromSeconds(2));
                Console.WriteLine("Tasks are still running");
            }

            Assert.IsTrue(Directory.EnumerateFiles(BackupsOutputDirectory).Any());
        }

        [Test]
        public void ScriptSprocPermissions_CheckIfFileWithPermissionsIsCreated_FileWithSprocPermissionsCreated()
        {
            SqlManager.ScriptPermissions(_connectionString);
        }

        [Test]
        public void CompareSprocs_UsingComparisonRunner_Agent()
        {
            using (var dmanager = new DirectoryHelper(ComparisonOutputDirectory, true))
            {
                var backupRunner =
                    new ComparisonRunner(
                        _connectionString, ComparisonOutputDirectory);

                backupRunner.GenerateSprocComparisonFiles();
                backupRunner.GetMissingProcs();
                backupRunner.GetNewProcs();

                Assert.IsTrue(dmanager.HasFiles());
            }
        }
    }
}