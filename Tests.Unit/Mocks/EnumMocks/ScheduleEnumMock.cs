using System.ComponentModel;
using Tests.Unit.Mocks.SettingsMocks;

namespace Tests.Unit.Mocks.EnumMocks
{
    public enum ScheduleEnumMock
    {
        [Description(TextSettings.Daily)] Daily,
        [Description(TextSettings.Weekly)] Weekly,
        [Description(TextSettings.Monthly)] Monthly
    }
}