using System.Configuration;

using Service.Layer.ScriptRunnerService.Agents;

namespace Service.Layer.ScriptRunnerService.Runner.Base
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