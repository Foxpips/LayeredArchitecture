using System;
using System.Linq;

using Business.Logic.Layer.DataTypes;

using Core.Library.Extensions;

using Data.Access.Layer.EntityFramework.Contexts;

namespace Data.Access.Layer.EntityFramework
{
    public class PersistenceManager
    {
        private static void Connect(Action<BloggingContext> work)
        {
            using (var database = new BloggingContext())
            {
                work(database);
            }
        }

        public void Save()
        {
            Connect(database =>
            {
                database.Blogs.Add(new Blog {Name = "Simon"});

                database.SaveChanges();
            });
        }

        public void Search()
        {
            Connect(database =>
            {
                var query = from b in database.Blogs orderby b.Name select b;

                query.ForEach(item => Console.WriteLine(item.Name));

                Console.WriteLine();
            });
        }
    }
}