using System;
using System.Configuration;

using Rhino.ServiceBus.Config;

namespace TaskRunner.Core.Infrastructure.Configuration
{
    public static class BusConfig
    {
        private static readonly Lazy<BusConfigurationSection> _busConfigurationSection =
            new Lazy<BusConfigurationSection>(
                () => (BusConfigurationSection) ConfigurationManager.GetSection("rhino.esb"));

        public static int GetNumberOfRetries()
        {
            if (_busConfigurationSection.Value.Bus.NumberOfRetries != null)
            {
                return _busConfigurationSection.Value.Bus.NumberOfRetries.Value;
            }
            return 0;
        }

        public static string GetBusEndpoint()
        {
            return _busConfigurationSection.Value.Bus.Endpoint;
        }
    }
}