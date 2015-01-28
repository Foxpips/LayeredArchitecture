using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

using NUnit.Framework;

using Service.Layer.ScriptRunnerService.Managers;

namespace IntegrationTests.ScriptRunnerService
{
    [TestFixture]
    internal sealed class SqlCoreBackupTest
    {
        private string _connectionString;
        private string _rootdirString;

        [SetUp]
        public void Setup()
        {
            _connectionString = "server=sth3gisql;database=h3gi;uid=sa;pwd=kAnUTr@na5we;app=SqlScriptsRunner";
            _rootdirString = @"../../../Miscellaneous\StoredProcedures\";
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
            foreach (string sproc in sprocsInDatabaseList)
            {
                SqlManager.BackupSproc(_connectionString, sproc);
            }
        }

        [Test]
        public void ScriptSprocPermissions_CheckIfFileWithPermissionsIsCreated_FileWithSprocPermissionsCreated()
        {
            SqlManager.ScriptPermissions(_connectionString);
        }
    }
}