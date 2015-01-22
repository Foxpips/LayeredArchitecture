using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

using Buy4Now.Three.SqlRunner.Core.Managers;

using NUnit.Framework;

using UnitTest.Tests.Base;

namespace UnitTest.Tests
{
    [TestFixture]
    internal sealed class SqlCoreBackupTest : TestBase
    {
        [Test]
        public void BackupSprocs_CheckIfProcsAreBackedup_AFileContainingSprocsContents()
        {
            const string sprocName = "b4nCheckProcsExist";
            SqlManager.BackupSproc(CONNECTION_STRING, sprocName);

            string path = @"c:\SqlRunner\StoredProcedures\Backup_" + DateTime.Now.ToString("yyyy MMMM dd");
            IEnumerable<string> lines = File.ReadLines(path + @"\b4nCheckProcsExist.sql");
            Assert.That(lines.Any(x => x.Contains("b4nCheckProcsExist")));
        }

        [Test]
        public void BackupSprocs_CheckAllSprocsBackedUp_AllDbSprocsCopiedLocally()
        {
            IEnumerable<string> sprocsInDatabaseList = SqlManager.GetSprocs_InDatabase_List(CONNECTION_STRING);
            foreach (string sproc in sprocsInDatabaseList)
            {
                SqlManager.BackupSproc(CONNECTION_STRING, sproc);
            }
        }

        [Test]
        public void ScriptSprocPermissions_CheckIfFileWithPermissionsIsCreated_FileWithSprocPermissionsCreated()
        {
            SqlManager.ScriptPermissions(CONNECTION_STRING);
        }
    }
}