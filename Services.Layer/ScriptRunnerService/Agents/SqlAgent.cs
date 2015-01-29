using System.Collections.Generic;
using System.IO;
using System.Linq;

using Service.Layer.ScriptRunnerService.Collections;
using Service.Layer.ScriptRunnerService.Executors;
using Service.Layer.ScriptRunnerService.SqlManagers;

namespace Service.Layer.ScriptRunnerService.Agents
{
    public sealed class SqlAgent
    {
        private readonly SqlCollection _sqlCollection;
        private string DatabaseConnection { get; set; }
        private string SprocDirLocation { get; set; }

        public SqlAgent(string database, string rootDir, string collectionOutput = @"..\..\..\Miscellaneous\StoredProcedures")
        {
            DatabaseConnection = database;
            SprocDirLocation = rootDir;
            _sqlCollection = new SqlCollection(SqlManager.GetSprocs_InDatabase_List(database),
                SqlManager.GetSprocs_UnderVersionControl(collectionOutput));
        }

        public IEnumerable<string> GetProcs_Missing_FromVersionControl_List()
        {
            return _sqlCollection.Dblist.Where(proc => !_sqlCollection.Locallist.Contains(proc)).ToList();
        }

        public IEnumerable<string> GetProcs_Missing_FromDatabase_List()
        {
            return _sqlCollection.Locallist.Where(proc => !_sqlCollection.Dblist.Contains(proc)).ToList();
        }

        internal void DropExistingSprocs()
        {
             string dropsprocsTxt = SprocDirLocation + "DropSprocs.txt";
            var streamWriter = new StreamWriter(dropsprocsTxt);
            foreach (string proc in _sqlCollection.Dblist)
            {
                streamWriter.Write("DROP PROCEDURE " + proc + "\n");
            }
            streamWriter.Close();
            SqlExecutor.Execute(dropsprocsTxt, DatabaseConnection);
        }

        internal void CreateNewSprocs()
        {
            SqlExecutor.Execute(SqlManager.GetSprocsPaths(SprocDirLocation), DatabaseConnection);
        }

        public void GenerateProcs_NotInDatabase_File()
        {
            var streamWriter = new StreamWriter(SprocDirLocation + "NewSprocs.txt");
            foreach (
                string proc in
                    _sqlCollection.Locallist.Where(proc => !_sqlCollection.Dblist.Contains(proc)).ToList())
            {
                streamWriter.Write(proc + "\n");
            }
            streamWriter.Close();
        }

        public void GenerateProcs_NotUnderVersionControl_File()
        {
            var streamWriter = new StreamWriter(SprocDirLocation + "MissingSprocs.txt");
            foreach (
                string proc in
                    _sqlCollection.Dblist.Where(proc => !_sqlCollection.Locallist.Contains(proc)).ToList())
            {
                streamWriter.Write(proc + "\n");
            }
            streamWriter.Close();
        }

        public void BackupSprocs()
        {
            foreach (string procName in SqlManager.GetSprocs_InDatabase_List(DatabaseConnection))
            {
                SqlManager.BackupSproc(DatabaseConnection, procName, SprocDirLocation);
            }
        }
    }
}