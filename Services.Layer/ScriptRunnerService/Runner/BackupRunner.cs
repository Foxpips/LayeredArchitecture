using Service.Layer.ScriptRunnerService.Runner.Base;

namespace Service.Layer.ScriptRunnerService.Runner
{
    public class BackupRunner : RunnerBase
    {
        public BackupRunner(string database, string path = "") : base(database, path)
        {
        }

        public void BackUpSprocs()
        {
            Agent.BackupSprocs();
        }
    }
}