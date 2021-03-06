﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;

using Business.Logic.Layer.Helpers;
using Business.Objects.Layer.Interfaces.Logging;
using Business.Objects.Layer.Pocos.Sql;

using Dependency.Resolver.Loaders;

using Gui.Layer.Controllers;

using NUnit.Framework;

using Service.Layer.ScriptRunnerService.Runner;
using Service.Layer.ScriptRunnerService.SqlManagers;

namespace Tests.Integration.ScriptRunnerServiceTests
{
    [TestFixture]
    internal sealed class SqlCoreTests
    {
        private string _connectionString;
        private string _rootdirString;
        public string BackupsOutputDirectory { get; set; }
        public string ComparisonOutputDirectory { get; set; }

        [SetUp]
        public void Setup()
        {
            var container = new DependencyManager().ConfigureStartupDependencies();
            _connectionString =
                new JsonHelper(container.GetInstance<ICustomLogger>()).DeserializeJsonFromFile<SqlServerCredentials>(
                    @"..\..\..\Miscellaneous\Json\Servers.json").ConnectionString;
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

            while (BackupController.UpdateAsyncTaskManager.TasksInProgress())
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