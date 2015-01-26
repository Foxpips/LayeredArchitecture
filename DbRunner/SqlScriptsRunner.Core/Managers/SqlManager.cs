using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;

using Buy4Now.Three.SqlRunner.Core.Helpers;

namespace Buy4Now.Three.SqlRunner.Core.Managers
{
    internal sealed class SqlManager
    {
        internal static IEnumerable<string> GetSprocs_UnderVersionControl(String rootDir)
        {
            var directoryInfo = new DirectoryInfo(rootDir);
            List<string> localList =
                directoryInfo.GetFiles().Select(fileInfo => Path.GetFileNameWithoutExtension(fileInfo.Name)).ToList();

            return localList;
        }

        internal static IEnumerable<string> GetSprocsPaths(String rootDir)
        {
            var directoryInfo = new DirectoryInfo(rootDir);
            List<string> localList =
                directoryInfo.GetFiles().Select(fileInfo => rootDir + fileInfo.Name).ToList();

            return localList;
        }

        internal static IEnumerable<string> GetSprocs_InDatabase_List(string connectionString)
        {
            var dbSprocList = new List<string>();
            using (var con = new SqlConnection(connectionString))
            {
                using (var cmd = new SqlCommand("b4nCheckProcsExist", con) {CommandType = CommandType.StoredProcedure})
                {
                    con.Open();
                    var sqlDataAdapter = new SqlDataAdapter(cmd);
                    var dataTable = new DataTable();

                    sqlDataAdapter.Fill(dataTable);
                    dbSprocList.AddRange(BuildList(dataTable));
                    con.Close();
                }
            }
            return dbSprocList;
        }

        internal static void BackupSproc(string connectionString, string sprocName)
        {
            var contents = new StringBuilder();
            using (var conn = new SqlConnection(connectionString))
            {
                using (var cmd = new SqlCommand("sp_helptext", conn) {CommandType = CommandType.StoredProcedure})
                {
                    conn.Open();
                    cmd.Parameters.Add(new SqlParameter("@objname", sprocName));
                    SqlDataReader sqlDataReader = cmd.ExecuteReader();

//                    using (var reader = new SafeDataReader(sqlDataReader))
//                    {
                    while (sqlDataReader.Read())
                    {
                        contents.Append(sqlDataReader.GetOrdinal("text"));
                    }
//                    }
                    conn.Close();
                }

                GetSprocPermissions(sprocName, conn, contents);
                SqlHelper.CreateFile(sprocName, contents.ToString());
            }
        }

        private static void GetSprocPermissions(string sprocName, SqlConnection conn, StringBuilder contents)
        {
            using (var cmd = new SqlCommand("h3giGetSprocPermissions", conn) {CommandType = CommandType.StoredProcedure}
                )
            {
                conn.Open();
                cmd.Parameters.Add(new SqlParameter("@objname", sprocName));
                SqlDataReader sqlDataReader = cmd.ExecuteReader();

//                using (var reader = new SafeDataReader(sqlDataReader))
//                {
                while (sqlDataReader.Read())
                    {
                        contents.Append(sqlDataReader.GetString(0) + " " + sqlDataReader.GetString(1) + " " + sqlDataReader.GetString(2) +
                                        " " + sqlDataReader.GetString(3) + " " + sqlDataReader.GetString(4) + " " +
                                        sqlDataReader.GetString(5));
                        contents.Append("\nGO" + "\n");
                    }
//                }
                conn.Close();
            }
        }

        private static IEnumerable<string> BuildList(DataTable dataTable)
        {
            // ReSharper disable once LoopCanBeConvertedToQuery (Iterator is faster)
            foreach (DataRow row in dataTable.Rows)
            {
                yield return row[0].ToString();
            }
        }

        internal static void ScriptPermissions(string connectionString)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                using (
                    var command = new SqlCommand("b4nScriptProcPermissions", connection)
                    {
                        CommandType = CommandType.StoredProcedure
                    })
                {
                    connection.Open();
                    SqlDataReader sqlDataReader = command.ExecuteReader();
                    var contents = new StringBuilder();
//                    using (var reader = new SafeDataReader(sqlDataReader))
//                    {
                    while (sqlDataReader.Read())
                        {
                            contents.Append(sqlDataReader.GetString(0));
                            contents.Append(sqlDataReader.GetString(1));
                            contents.Append(sqlDataReader.GetString(2));
                            contents.Append(sqlDataReader.GetString(3));
                            contents.Append(sqlDataReader.GetString(4));
                            contents.Append(sqlDataReader.GetString(5));
                            contents.Append("\n");
                        }
                        SqlHelper.CreateFile("Grant_Permissions", contents.ToString());
//                    }
                }
            }
        }
    }
}