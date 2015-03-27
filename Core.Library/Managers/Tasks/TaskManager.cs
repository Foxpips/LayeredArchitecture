using System;
using System.Linq;
using System.Reflection;

using Business.Logic.Layer.Interfaces.Startup;

namespace Core.Library.Managers.Tasks
{
    public class TaskManager
    {
        public static void ExecuteStartupTasks()
        {
            var exportedTypes = Assembly.GetExecutingAssembly().GetExportedTypes();

            foreach (
                var exportedType in
                    exportedTypes.Where(exportedType => (typeof (IRunAtStartup)).IsAssignableFrom(exportedType)))
            {
                ((IRunAtStartup) Activator.CreateInstance(exportedType)).Execute();
            }
        }
    }
}