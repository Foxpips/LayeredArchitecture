using System.Reflection;

using BackupService.Exceptions;
using BackupService.Helpers;

using Common.Logging;

using Rhino.ServiceBus;

using TaskRunner.Common.Messages.Backup;

namespace BackupService.Common.Consumers
{
    public class CleanBackupsEventConsumer : ConsumerOf<CleanBackupsEvent>
    {
        private static readonly ILog _logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        
        public void Consume(CleanBackupsEvent message)
        {
            _logger.Info("Deleting Old Backups...");

            try
            {
                const string cTestarchives = @"C:\TestArchives";
                ArchiveHelper.DeleteOldBackups(cTestarchives);
            }
            catch (DeleteOldBackupsFailedException e)
            {
                _logger.Info("Old Backups could not be deleted, as the following error occurred {0}",e.InternalException);
            }
            
            _logger.Info("Old Backups Deleted");
        }
    }
}