using System;
using System.IO;

namespace Service.Layer.ScriptRunnerService.Helpers
{
    internal sealed class SqlHelper
    {
        internal static void CreateFile(string fileName, string fileContents, string sprocDirLocation = "")
        {
            if (string.IsNullOrEmpty(sprocDirLocation))
            {
                sprocDirLocation =
                    @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\Miscellaneous\StoredProcedures\Backup_" +
                    DateTime.Now.ToString("yyyy MMMM dd");
            }

            var dir = Directory.CreateDirectory(sprocDirLocation);
            var fileInfo = new FileInfo(Path.Combine(dir.FullName, fileName + ".sql"));

            using (var file = fileInfo.OpenWrite())
            {
                var streamWriter = new StreamWriter(file);
                streamWriter.Write(fileContents);
                streamWriter.Close();
            }
        }
    }
}