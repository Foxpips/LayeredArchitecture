using Buy4Now.Three.SqlRunner.Core.Runner.Base;

namespace Buy4Now.Three.SqlRunner.Core.Runner
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