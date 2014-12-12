using System.Data.Entity;

using Business.Logic.Layer.DataTypes;

namespace Data.Access.Layer.EntityFramework.Contexts
{
    public class BloggingContext : DbContext
    {
        public DbSet<Blog> Blogs { get; set; }
        public DbSet<Post> Posts { get; set; }
    }
}