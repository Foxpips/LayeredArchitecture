using System;
using System.Linq;
using System.Reflection;

using Business.Objects.Layer.Interfaces.Startup;

namespace Business.Logic.Layer.Managers.Tasks
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