using System;

namespace Business.Logic.Layer.Extensions
{
    public static class DateTimeExtender
    {
        public static int GetDaysBetween(this DateTime starDate, DateTime endDate)
        {
            var totalDays = 0;
            for (var i = starDate.DayOfYear; i <= endDate.DayOfYear; i++)
            {
                totalDays++;
            }
            return totalDays;
        }
    }
}
