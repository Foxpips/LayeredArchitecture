using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace FileHelper.Core
{
    public class FileFinder
    {
        public static void ProcessFiles(
            ICollection<string> extensions, Action<string> process)
        {
            foreach (var file in GetFiles_WithExtensions(Directory.GetCurrentDirectory(), extensions))
            {
                process(file);
            }
        }

        private static IEnumerable<string> GetFiles_WithExtensions(string directory, ICollection<string> extensions)
        {
            IEnumerable<string> files =
                Directory.EnumerateFiles(directory, "*.*", SearchOption.AllDirectories)
                    .Where(x => extensions.Contains(Path.GetExtension(x)));
            return files;
        }
    }
}