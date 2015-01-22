using System.Configuration;

using Buy4Now.Three.SqlRunner.Core.Agents;

namespace Buy4Now.Three.SqlRunner.Core.Runner.Base
{
    public class RunnerBase
    {
        internal SqlAgent Agent { get; set; }

        public RunnerBase(string database)
        {
            Agent = new SqlAgent(ConfigurationManager.AppSettings[database], ConfigurationManager.AppSettings["rootDir"]);
        }
    }
}