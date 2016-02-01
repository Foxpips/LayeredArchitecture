using System.Diagnostics;
using System.IO;
using System.Linq;

namespace Framework.Layer.Loaders.Resource
{
    public class ResourceLoader
    {
        public static string GetResourceContent(string fileNameWithExtension)
        {
            var executingAssembly = typeof (ResourceLoader).Assembly;
            string result;
            using (var stream = executingAssembly.GetManifestResourceStream(executingAssembly
                .GetManifestResourceNames()
                .FirstOrDefault(rn => rn.Contains(fileNameWithExtension))))
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