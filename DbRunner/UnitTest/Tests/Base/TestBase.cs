using System;

using Buy4Now.Three.SqlRunner.Core.Agents;

namespace UnitTest.Tests.Base
{
    internal class TestBase
    {
        public static readonly SqlAgent SqlAgent = new SqlAgent(CONNECTION_STRING, ROOTDIR_STRING);

        protected const String CONNECTION_STRING_UAT =
            "server=sth3gisql;database=h3gi;uid=sa;pwd=sufruvusP!w9;app=SqlScriptsRunner"; 
        protected const String CONNECTION_STRING =
            "server=sth3gisql;database=h3gi;uid=sa;pwd=kAnUTr@na5we;app=SqlScriptsRunner";

        protected const String ROOTDIR_STRING = @"c:\Development\H3GI\Trunk\ThreeSql\h3gi\dbo\Stored Procedures\";
    }
}