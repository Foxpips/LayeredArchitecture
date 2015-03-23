using System;
using System.Linq;

using Business.Logic.Layer.Pocos.Data;

using Core.Library.Extensions;

using Data.Access.Layer.EntityFramework.Contexts;

namespace Data.Access.Layer.EntityFramework.Managers
{
    public class BlogsManager : DbManager<BloggingContext>
    {
        public void Save(Blog blog)
        {
            Connect(database => database.Blogs.Add(blog));
        }

        public void Add(int id, Post post)
        {
            Connect(database => database.Blogs.Find(id).Posts.Add(post));
        }

        public bool Search(Blog blog)
        {
            return Connect(database => database.Blogs.Find(blog.Id) != null);
        }

        public void PrintAll()
        {
            Connect(database =>
            {
                var query = from b in database.Blogs orderby b.Name select b;

                query.ForEach(item => Console.WriteLine(item.Name));
            });
        }

        public int Count()
        {
            return Connect(database => database.Blogs.Count());
        }

        public void Truncate()
        {
            Connect(data => data.Blogs.ForEach(x => data.Blogs.Remove(x)));
        }
    }
}