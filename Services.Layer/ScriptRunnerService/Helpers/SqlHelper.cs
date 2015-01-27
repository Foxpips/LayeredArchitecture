using System;
using System.IO;

namespace Service.Layer.ScriptRunnerService.Helpers
{
    sealed class SqlHelper
    {
        internal static void CreateFile(string fileName,string fileContents)
        {
            var path = @"C:\Users\smarkey\Documents\GitHub\LayeredArchitecture\Miscellaneous\StoredProcedures\Backup_" + DateTime.Now.ToString("yyyy MMMM dd");

            var dir = Directory.CreateDirectory(path);
            var fileInfo = new FileInfo(Path.Combine(dir.FullName,fileName+".sql"));

            using (var file = fileInfo.OpenWrite())
            {
                var streamWriter = new StreamWriter(file);
                streamWriter.Write(fileContents);
                streamWriter.Close();
            }
        }
    }
}