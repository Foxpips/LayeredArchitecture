using Service.Layer.ScriptRunnerService.Runner.Base;

namespace Service.Layer.ScriptRunnerService.Runner
{
    public class BackupRunner : RunnerBase
    {
        public BackupRunner(string database) : base(database)
        {
        }

        public void BackUpSprocs()
        {
            Agent.BackupSprocs();
        }
    }
}