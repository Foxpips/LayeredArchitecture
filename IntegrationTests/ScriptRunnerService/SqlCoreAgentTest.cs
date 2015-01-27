using NUnit.Framework;
using NUnit.Framework.SyntaxHelpers;

using Service.Layer.ScriptRunnerService.Agents;

namespace IntegrationTests.ScriptRunnerService
{
    [TestFixture]
    internal sealed class SqlCoreAgentTest
    {
        private SqlAgent SqlAgent { get; set; }

        [SetUp]
        public void Setup()
        {
            SqlAgent = new SqlAgent("server=sth3gisql;database=h3gi;uid=sa;pwd=kAnUTr@na5we;app=SqlScriptsRunner",
                @"../../../Miscellaneous\StoredProcedures\");
        }

        [Test]
        public void GetMissingProcs_SprocsAreUpdate_SprocsAreRunIn()
        {
            Assert.That(SqlAgent.GetProcs_Missing_FromVersionControl_List(),Is.Not.Null);
        }

        [Test]
        public void GetNewProcs_SprocsAreUpdate_SprocsAreRunIn()
        {
            Assert.That(SqlAgent.GetProcs_Missing_FromDatabase_List(),Is.Not.Null);
        }

        [Test]
        public void GenerateMissingSprocList_TestSprocComparison_2FilesGenerated()
        {
            SqlAgent.GenerateProcs_NotInDatabase_File();
            SqlAgent.GenerateProcs_NotUnderVersionControl_File();
        }
    }
}