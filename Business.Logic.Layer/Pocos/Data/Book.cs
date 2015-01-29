using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Business.Logic.Layer.Pocos.Data
{
    [Table("Books")]
    public class Book
    {
        [Key]
        public int Id { get; set; }

        public string Name { get; set; }
        public string Isbn { get; set; }

        // This is to maintain the many reviews associated with a book entity
        public virtual ICollection<Review> Reviews { get; set; }
    }
}