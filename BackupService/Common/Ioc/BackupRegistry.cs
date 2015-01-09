using StructureMap.Configuration.DSL;

using TaskRunner.Core.Infrastructure.Helpers;

namespace BackupService.Common.Ioc
{
    public class BackupRegistry : Registry
    {
        public BackupRegistry()
        {
            Scan(scan => For<IMailService>().Use<MailService>());
        }
    }
}