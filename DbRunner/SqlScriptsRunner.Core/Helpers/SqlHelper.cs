using System;
using System.IO;

namespace Buy4Now.Three.SqlRunner.Core.Helpers
{
    sealed class SqlHelper
    {
        internal static void CreateFile(string fileName,string fileContents)
        {
            var path = @"c:\SqlRunnerOutput\Backup_" + DateTime.Now.ToString("yyyy MMMM dd");

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