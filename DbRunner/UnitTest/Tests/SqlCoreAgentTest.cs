using NUnit.Framework;

using UnitTest.Tests.Base;

namespace UnitTest.Tests
{
    [TestFixture]
    internal sealed class SqlCoreAgentTest : TestBase
    {
        [Test]
        public void GetMissingProcs_SprocsAreUpdate_SprocsAreRunIn()
        {
            Assert.NotNull(SqlAgent.GetProcs_Missing_FromVersionControl_List());
        }

        [Test]
        public void GetNewProcs_SprocsAreUpdate_SprocsAreRunIn()
        {
            Assert.NotNull(SqlAgent.GetProcs_Missing_FromDatabase_List());
        }

        [Test]
        public void GenerateMissingSprocList_TestSprocComparison_2FilesGenerated()
        {
            SqlAgent.GenerateProcs_NotInDatabase_File();
            SqlAgent.GenerateProcs_NotUnderVersionControl_File();
        }
    }
}