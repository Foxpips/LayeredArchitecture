using System;
using System.Collections.Generic;
using System.IO;

namespace FileFinder
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            if (args.Length != 1)
            {
                Console.WriteLine("FileFinder.exe .exe");
                return;
            }

            string searchPattern = args[0];
            if (searchPattern == null)
            {
                Console.WriteLine("FileFinder.exe .exe");
                return;
            }

            using (var streamWriter = new StreamWriter(Path.Combine(Environment.CurrentDirectory, "output.txt")))
            {
                IEnumerable<string> files = Directory.EnumerateFiles(Environment.CurrentDirectory, "*.*",
                    SearchOption.AllDirectories);
                foreach (string file in files)
                {
                    var fileInfo = new FileInfo(file);
                    if (fileInfo.Extension.Equals(searchPattern, StringComparison.OrdinalIgnoreCase))
                    {
                        Console.WriteLine(file);
                        streamWriter.WriteLine(file);
                    }
                }
            }

            Console.WriteLine("Done");
        }
    }
}