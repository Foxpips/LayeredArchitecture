using System;
using System.Configuration;

using Rhino.ServiceBus.Config;

namespace TaskRunner.Core.Infrastructure.ServiceBus
{
    public static class BusConfig
    {
        private static readonly Lazy<BusConfigurationSection> _busConfigurationSection =
            new Lazy<BusConfigurationSection>(() => (BusConfigurationSection) ConfigurationManager.GetSection("rhino.esb"));

        public static int GetNumberOfRetries()
        {
            return _busConfigurationSection.Value.Bus.NumberOfRetries.Value;
        }

        public static string GetBusEndpoint()
        {
            return _busConfigurationSection.Value.Bus.Endpoint;
        }
    }
}