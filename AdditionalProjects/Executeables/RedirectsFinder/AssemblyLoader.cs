using System;
using System.Linq;
using System.Reflection;

namespace RedirectsFinder
{
    public class AssemblyLoader
    {
        public static void LoadAssemblies()
        {
            AppDomain.CurrentDomain.AssemblyResolve += LoadAssemblyDlls;
        }

        private static Assembly LoadAssemblyDlls(object sender, ResolveEventArgs args)
        {
            String dllName = new AssemblyName(args.Name).Name + ".dll";
            var assem = Assembly.GetExecutingAssembly();
            
            Assembly executingAssembly = Assembly.GetExecutingAssembly();
            Console.WriteLine("Executing Assembly {0}", executingAssembly);

            String resourceName = assem.GetManifestResourceNames().FirstOrDefault(rn => rn.EndsWith(dllName));
            Console.WriteLine("Resource Name {0}", resourceName);

            if (resourceName != null)
            {
                using (var stream = assem.GetManifestResourceStream(resourceName))
                {
                    if (stream != null)
                    {
                        var assemblyData = new Byte[stream.Length];

                        stream.Read(assemblyData, 0, assemblyData.Length);

                        return Assembly.Load(assemblyData);
                    }
                }
            }
            return null;
        }
    }
}