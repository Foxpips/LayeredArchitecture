using System.Collections.Generic;
using System.Linq;

using Business.Objects.Layer.Pocos.Data;

using Data.Access.Layer.EntityFramework.Contexts;

namespace Data.Access.Layer.EntityFramework.Managers
{
    public class BooksManager : DbManager<BooksContext>
    {
        public List<Book> GetList()
        {
            List<Book> list = null;
            Connect(database => { list = database.Books.ToList(); });
            return list;
        }

        public List<Book> GetList2()
        {
            return Connect(database => database.Books.ToList());
        }
    }
}