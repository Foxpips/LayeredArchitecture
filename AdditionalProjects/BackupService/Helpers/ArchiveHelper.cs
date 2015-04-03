using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;

using BackupService.Exceptions;

namespace BackupService.Helpers
{
    public class ArchiveHelper
    {
        public static void ArchiveDirectories(string directory)
        {
            try
            {
                var directories = Directory.EnumerateDirectories(directory, "*", SearchOption.AllDirectories).ToList();
                var archives = Directory.EnumerateFiles(directory, "*.zip", SearchOption.AllDirectories).ToList();

                ArchiveDirectories(directories, archives);
            }
            catch (Exception e)
            {
                throw new ArchiveDirectoriesFailedException("Error archiving directories", e);
            }
        }

        public static void DeleteOldBackups(string directory)
        {
            try
            {
                DeleteOldArchives(Directory.EnumerateFiles(directory, "*.zip", SearchOption.AllDirectories).ToList(), 5);
                DeleteOldDirectories(
                    Directory.EnumerateDirectories(directory, "*", SearchOption.AllDirectories).ToList());
            }
            catch (Exception e)
            {
                throw new DeleteOldBackupsFailedException("Error deleting backups", e);
            }
        }

        private static void DeleteOldDirectories(IEnumerable<string> directories)
        {
            foreach (var path in directories)
            {
                Console.WriteLine("Directory Path:{0}", path);
                Directory.Delete(path, true);
            }
        }

        private static void ArchiveDirectories(IEnumerable<string> directories, ICollection<string> existingArchives)
        {
            foreach (var archive in directories)
            {
                if (!existingArchives.Contains(archive + ".zip"))
                {
                    ZipFile.CreateFromDirectory(archive, archive + ".zip", CompressionLevel.Optimal, true);
                }
            }
        }

        private static void DeleteOldArchives(IEnumerable<string> archives, int backupArchiveAmount)
        {
            var files = archives.Select(x => new
            {
                FilePath = x,
                LastWriteTime = File.GetLastWriteTime(x)
            });

            var toDelete = files.OrderByDescending(x => x.LastWriteTime).Skip(backupArchiveAmount).ToList();

            foreach (var archive in toDelete)
            {
                Console.WriteLine("File Path:{0}, File Name:{1}", archive.FilePath, archive.LastWriteTime);
                File.Delete(archive.FilePath);
            }
        }
    }
}