using Service.Layer.ScriptRunnerService.Agents;

namespace Service.Layer.ScriptRunnerService.Runner.Base
{
    public class RunnerBase
    {
        internal SqlAgent Agent { get; set; }

        public RunnerBase(string database, string outputPath)
        {
            Agent = new SqlAgent(database, outputPath);
        }
    }
}