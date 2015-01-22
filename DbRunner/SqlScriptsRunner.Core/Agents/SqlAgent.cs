using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

using Buy4Now.Three.SqlRunner.Core.Collections;
using Buy4Now.Three.SqlRunner.Core.Executors;
using Buy4Now.Three.SqlRunner.Core.Managers;

namespace Buy4Now.Three.SqlRunner.Core.Agents
{
    internal sealed class SqlAgent
    {
        private readonly SqlCollection _sqlCollection;
        private string DatabaseConnection { get; set; }
        private string SprocDirLocation { get; set; }

        internal SqlAgent(String database, String rootDir)
        {
            DatabaseConnection = database;
            SprocDirLocation = rootDir;
            _sqlCollection = new SqlCollection(SqlManager.GetSprocs_InDatabase_List(database),
                SqlManager.GetSprocs_UnderVersionControl(rootDir));
        }

        internal IEnumerable<string> GetProcs_Missing_FromVersionControl_List()
        {
            return _sqlCollection.Dblist.Where(proc => !_sqlCollection.Locallist.Contains(proc)).ToList();
        }

        internal IEnumerable<string> GetProcs_Missing_FromDatabase_List()
        {
            return _sqlCollection.Locallist.Where(proc => !_sqlCollection.Dblist.Contains(proc)).ToList();
        }

        internal void DropExistingSprocs()
        {
            var streamWriter = new StreamWriter(@"c:\SqlRunnerOutput\DropSprocs.sql");
            foreach (string proc in _sqlCollection.Dblist)
            {
                streamWriter.Write("DROP PROCEDURE " + proc + "\n");
            }
            streamWriter.Close();
            SqlExecutor.Execute(@"c:\SqlRunnerOutput\DropSprocs.sql", DatabaseConnection);
        }

        internal void CreateNewSprocs()
        {
            SqlExecutor.Execute(SqlManager.GetSprocsPaths(SprocDirLocation), DatabaseConnection);
        }

        internal void GenerateProcs_NotInDatabase_File()
        {
            var streamWriter = new StreamWriter(@"c:\SqlRunnerOutput\NewSprocs.txt");
            foreach (
                string proc in
                    _sqlCollection.Locallist.Where(proc => !_sqlCollection.Dblist.Contains(proc)).ToList())
            {
                streamWriter.Write(proc + "\n");
            }
            streamWriter.Close();
        }

        internal void GenerateProcs_NotUnderVersionControl_File()
        {
            var streamWriter = new StreamWriter(@"c:\SqlRunnerOutput\MissingSprocs.txt");
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
                SqlManager.BackupSproc(DatabaseConnection, procName);
                SqlManager.ScriptPermissions(DatabaseConnection);
            }
        }
    }
}