using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Linq;

using FileHelper.Core;

namespace RedirectsFinder
{
    public class Program
    {
        //        //This is to ensure we do not list the same redirect twice as we do not show what is being redirected to this
        //        //and thus it simply shows as multiples of the same redirect in the file which is of no use to three as they simply
        //        //want a list of all the redirects regardless if they are used for multiple urls in numerous configs.
        //        public static List<string> _previousRedirect = new List<string>();

        public static void Main(string[] args)
        {
            CleanupFiles();
            AssemblyLoader.LoadAssemblies();
            FindRedirects(args);
        }

        private static void CleanupFiles()
        {
            File.Delete(Path.Combine(Environment.CurrentDirectory, "Redirect_Destinations.txt"));
            File.Delete(Path.Combine(Environment.CurrentDirectory, "Redirect_Source.txt"));
        }

        private static void FindRedirects(string[] args)
        {
            if (!(args.Length > 0))
            {
                args = new[] {".config"};
            }

            FileFinder.ProcessFiles(args,
                file =>
                {
                    Console.WriteLine("Processing file {0} ... ", file);

                    var previousRedirect = new List<string>();
                    XDocument xDocument = XDocument.Load(file);
                    List<XElement> redirectElementList = xDocument.Descendants("httpRedirect").ToList();

                    using (
                        var streamWriter =
                            new StreamWriter(Path.Combine(Environment.CurrentDirectory, "Redirect_Destinations.txt"),
                                true))
                    {
                        foreach (var element in redirectElementList)
                        {
                            var enabledAttribute = element.Attribute("enabled");
                            if (enabledAttribute != null)
                            {
                                var redirectValue = element.Attribute("destination").Value;
                                if (!enabledAttribute.Value.Equals("false", StringComparison.OrdinalIgnoreCase) &&
                                    !previousRedirect.Contains(redirectValue))
                                {
                                    WriteRedirectSource(file, element);
                                    streamWriter.WriteLine(redirectValue);
                                    previousRedirect.Add(redirectValue);
                                }
                            }
                        }
                    }
                });
        }

        private static void WriteRedirectSource(string file, XNode element)
        {
            string redirectSourcePath = null;
            var pathLocation = element.Ancestors("location").FirstOrDefault();

            if (pathLocation != null)
            {
                redirectSourcePath = pathLocation.Attribute("path").Value;
            }

            using (
                var streamWriter = new StreamWriter(Path.Combine(Environment.CurrentDirectory, "Redirect_Source.txt"),
                    true))
            {
                streamWriter.WriteLine(!String.IsNullOrEmpty(redirectSourcePath) ? redirectSourcePath : Path.GetDirectoryName(file));
            }
        }
    }
}