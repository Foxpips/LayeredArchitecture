using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;

using Buy4Now.Three.SqlRunner.Core.Collections;

using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.Smo;

namespace Buy4Now.Three.SqlRunner.Core.Executors
{
    public class SqlExecutor
    {
        public static void Execute(IEnumerable<string> sqlFiles, string connectionString)
        {
            foreach (string file in sqlFiles)
            {
                Execute(file, connectionString);
            }
        }

        internal static void Execute(string filePath, string connectionString)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                ExecuteSqlInFile(filePath, connection);
            }
        }

        private static void ExecuteSqlInFile(string file, SqlConnection conn)
        {
            SqlCollection.CurrentFile = file;
            string content = File.ReadAllText(file);
            var server = new Server(new ServerConnection(conn));

            server.ConnectionContext.ExecuteNonQuery(content);
        }
    }
}