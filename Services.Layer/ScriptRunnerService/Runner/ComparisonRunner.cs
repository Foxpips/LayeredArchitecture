using System;
using System.Collections.Generic;

using Service.Layer.ScriptRunnerService.Runner.Base;

namespace Service.Layer.ScriptRunnerService.Runner
{
    public sealed class ComparisonRunner : RunnerBase
    {
        public ComparisonRunner(string database) : base(database)
        {
        }

        public void GenerateSprocComparisonFiles()
        {
            Agent.GenerateProcs_NotUnderVersionControl_File();
            Agent.GenerateProcs_NotInDatabase_File();
        }

        public IEnumerable<String> GetMissingProcs()
        {
            return Agent.GetProcs_Missing_FromVersionControl_List();
        }

        public IEnumerable<String> GetNewProcs()
        {
            return Agent.GetProcs_Missing_FromDatabase_List();
        }
    }
}