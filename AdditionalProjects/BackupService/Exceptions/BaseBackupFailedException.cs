using System;

namespace BackupService.Exceptions
{
    public class BaseBackupFailedException : Exception
    {
        public string ErrorMessage { get; set; }
        public Exception InternalException { get; set; }
    }

    public class ArchiveDirectoriesFailedException : BaseBackupFailedException
    {
        public ArchiveDirectoriesFailedException(string error, Exception internalException)
        {
            ErrorMessage = error;
            InternalException = internalException;
        }
    }

    public class DeleteOldBackupsFailedException : BaseBackupFailedException
    {
        public DeleteOldBackupsFailedException(string error, Exception internalException)
        {
            ErrorMessage = error;
            InternalException = internalException;
        }
    }
}