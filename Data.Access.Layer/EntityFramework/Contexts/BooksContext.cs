using System.Data.Entity;

using Business.Logic.Layer.Pocos;
using Business.Logic.Layer.Pocos.Data;

namespace Data.Access.Layer.EntityFramework.Contexts
{
    public class BooksContext : DbContext
    {
        public DbSet<Book> Books { get; set; }
        public DbSet<Review> Reviews { get; set; }
    }
}