using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Business.Logic.Layer.Pocos.Data
{
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