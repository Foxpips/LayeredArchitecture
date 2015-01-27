using System.IO;

using Service.Layer.ScriptRunnerService.Runner.Base;

namespace Service.Layer.ScriptRunnerService.Runner
{
    public sealed class SprocRunner : RunnerBase
    {
        public SprocRunner(string database) : base(database)
        {
        }

        public void RunProceduresIntoDatabase()
        {
            Directory.CreateDirectory(@"c:\SqlRunnerOutput");
            Agent.DropExistingSprocs();
            Agent.CreateNewSprocs();
        }
    }
}