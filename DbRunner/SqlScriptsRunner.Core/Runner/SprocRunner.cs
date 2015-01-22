using System.IO;

using Buy4Now.Three.SqlRunner.Core.Runner.Base;

namespace Buy4Now.Three.SqlRunner.Core.Runner
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