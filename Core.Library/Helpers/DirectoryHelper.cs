using System;
using System.IO;
using System.Linq;

using Business.Logic.Layer.Exceptions.Basic;

namespace Core.Library.Helpers
{
    public class DirectoryHelper : IDisposable
    {
        private string DirectoryPath { get; set; }

        public DirectoryHelper(string directory, bool deleteExisting = false)
        {
            DirectoryPath = directory;
            var exists = Directory.Exists(DirectoryPath);

            if (exists)
            {
                if (deleteExisting)
                {
                    Directory.Delete(DirectoryPath, true);
                }
                else
                {
                    throw new DirectoryAlreadyExists();
                }
            }

            Directory.CreateDirectory(DirectoryPath);
        }

        public bool HasFiles()
        {
            return Directory.EnumerateFiles(DirectoryPath).Any();
        }

        public void Dispose()
        {
            Directory.Delete(DirectoryPath, true);
        }
    }
}