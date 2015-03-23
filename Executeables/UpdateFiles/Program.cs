using System;
using System.IO;
using System.Text;

using FileHelper.Core;

namespace UpdateFiles
{
    internal class Program
    {
        public static void Main()
        {
            Console.WriteLine("Enter the file extensions to search for e.g. { .txt .csproj .html }");
            var readLine = Console.ReadLine();
            if (readLine != null)
            {
                Run(readLine.Split());
            }
        }

        public static void Run(string[] args)
        {
            Console.WriteLine("\nEnter Text to find");
            string find = Console.ReadLine();

            Console.WriteLine("\nEnter replacement text");
            string replaceWord = Console.ReadLine();

            FileFinder.ProcessFiles(args,
                (file) =>
                {
                    Console.WriteLine();
                    Console.WriteLine("\nProcessing file: {0}", file);

                    if (find != null)
                    {
                        string readAllText = File.ReadAllText(file);

                        if (readAllText.Contains(find))
                        {
                            DisplayAffectedLines(file, find, replaceWord);
                        }
                    }
                });
        }

        private static void DisplayAffectedLines(string searchFile, string searchWord, string replaceWord)
        {
            int counter = 0;

            string line;
            string readLine = "";

            var fileBuilder = new StringBuilder();
            var file = new StreamReader(searchFile);

            while ((line = file.ReadLine()) != null)
            {
                counter++;

                if (line.Contains(searchWord))
                {
                    Console.WriteLine("Line number {0} contains that search word: \n {1}", counter, line);
                    Console.WriteLine("Replace line y/n ?");
                    readLine = Console.ReadLine();
                }

                fileBuilder.AppendLine(readLine != null && readLine.Equals("y", StringComparison.OrdinalIgnoreCase)
                    ? line.Replace(searchWord, replaceWord)
                    : line);
            }

            file.Close();

            File.WriteAllText(searchFile, fileBuilder.ToString());
        }
    }
}