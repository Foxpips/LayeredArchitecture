using System;
using System.Reflection;

using BackupService.Exceptions;
using BackupService.Helpers;

using Common.Logging;

using Rhino.ServiceBus;

using TaskRunner.Common.Messages.Backup;

namespace BackupService.Common.Consumers
{
    public class CleanBackupsCommandConsumer : ConsumerOf<CleanBackupsCommand>
    {
        private static readonly ILog _logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private readonly IServiceBus _bus;

        public CleanBackupsCommandConsumer(IServiceBus bus)
        {
            _bus = bus;
        }

        public void Consume(CleanBackupsCommand message)
        {
            _logger.Info("Creating Backups...");
            Console.WriteLine("Creating Backups...");

            try
            {
                ArchiveHelper.ArchiveDirectories(@"C:\TestArchives");
                _bus.SendToSelf(new CleanBackupsEvent());
            }
            catch (ArchiveDirectoriesFailedException e)
            {
                _logger.Info("Backups not created, as the following error occurred {0}", e.InternalException);
            }

            _logger.Info("Backups Created.");
        }
    }
}