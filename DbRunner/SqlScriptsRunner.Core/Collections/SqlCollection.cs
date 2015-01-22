using System;
using System.Collections.Generic;

namespace Buy4Now.Three.SqlRunner.Core.Collections
{
    public class SqlCollection
    {
        public IEnumerable<string> Dblist { get; set; }
        public IEnumerable<string> Locallist { get; set; }
        public IEnumerable<string> ExistingSprocsList { get; set; }
        public static String CurrentFile { get; set; }

        public SqlCollection(IEnumerable<string> dblist, IEnumerable<string> locallist)
        {
            Dblist = dblist;
            Locallist = locallist;
        }
    }
}