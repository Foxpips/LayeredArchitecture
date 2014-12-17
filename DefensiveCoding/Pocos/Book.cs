using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Business.Logic.Layer.Pocos
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

    [Table("Reviews")]
    public class Review
    {
        [Key]
        public int ReviewId { get; set; }

        [ForeignKey("Book")]
        public int BookId { get; set; }

        public string ReviewText { get; set; }

        public virtual Book Book { get; set; }
    }
}