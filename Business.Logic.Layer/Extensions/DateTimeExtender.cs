using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Logic.Layer.Extensions
{
    public static class DateTimeExtender
    {
        public static int GetDaysBetween(this DateTime starDate, DateTime endDate)
        {
            var totalDays = 0;
            for (int i = starDate.DayOfYear; i <= endDate.DayOfYear; i++)
            {
                totalDays++;
            }
            return totalDays;
        }
    }
}
