using System.Diagnostics;
using System.IO;
using System.Linq;

namespace Framework.Layer.Loaders.Resource
{
    public class ResourceLoader
    {
        public static string Log4NetConfiguration()
        {
            var executingAssembly = typeof (ResourceLoader).Assembly;
            string result;
            using (var stream = executingAssembly.GetManifestResourceStream(executingAssembly
                .GetManifestResourceNames()
                .FirstOrDefault(rn => rn.Contains("log4net.xml"))))
            {
                Debug.Assert(stream != null, "stream cannot be null!");
                using (var reader = new StreamReader(stream))
                {
                    result = reader.ReadToEnd();
                }
            }
            return result;
        }
    }
}