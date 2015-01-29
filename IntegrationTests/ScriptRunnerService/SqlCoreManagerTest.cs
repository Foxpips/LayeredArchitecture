using NUnit.Framework;
using NUnit.Framework.SyntaxHelpers;

using Service.Layer.ScriptRunnerService.SqlManagers;

namespace IntegrationTests.ScriptRunnerService
{
    [TestFixture]
    internal sealed class SqlCoreManagerTest
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
        public void GetDatabaseSprocList_ReturnsListOfSprocs_FromDb()
        {
            Assert.That(SqlManager.GetSprocs_InDatabase_List(_connectionString), Is.Not.Null);
        }

        [Test]
        public void GetSprocsNames_GetsSprocsNames_FromDb()
        {
            Assert.That(SqlManager.GetSprocs_UnderVersionControl(_rootdirString), Is.Not.Null);
        }

        [Test]
        public void GetSprocsPaths_GetsFileNames_FromDir()
        {
            Assert.That(SqlManager.GetSprocsPaths(_rootdirString), Is.Not.Null);
        }
    }
}