using System;
using System.Data.Entity;

namespace Data.Access.Layer.EntityFramework.Managers
{
    public class DbManager<TContext> where TContext : DbContext, IDisposable, new()
    {
        public DbManager()
        {
            Database.SetInitializer(new DropCreateDatabaseIfModelChanges<TContext>());
        }

        public void Connect(Action<TContext> work)
        {
            using (var database = new TContext())
            {
                database.Database.Connection.Open();
                work(database);
                database.SaveChanges();
            }
        }

        public TReturn Connect<TReturn>(Func<TContext, TReturn> work)
        {
            using (var database = new TContext())
            {
                var result = work(database);
                database.SaveChanges();

                return result;
            }
        }
    }
}