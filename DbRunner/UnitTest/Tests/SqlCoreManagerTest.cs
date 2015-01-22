using Buy4Now.Three.SqlRunner.Core.Managers;

using NUnit.Framework;

using UnitTest.Tests.Base;

namespace UnitTest.Tests
{
    [TestFixture]
    internal sealed class SqlCoreManagerTest : TestBase
    {
        [Test]
        public void GetDatabaseSprocList_ReturnsListOfSprocs_FromDb()
        {
            Assert.NotNull(SqlManager.GetSprocs_InDatabase_List(CONNECTION_STRING));
        }

        [Test]
        public void GetSprocsNames_GetsSprocsNames_FromDb()
        {
            Assert.NotNull(SqlManager.GetSprocs_UnderVersionControl(ROOTDIR_STRING));
        }

        [Test]
        public void GetSprocsPaths_GetsFileNames_FromDir()
        {
            Assert.NotNull(SqlManager.GetSprocsPaths(ROOTDIR_STRING));
        }
    }
}