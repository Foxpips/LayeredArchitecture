﻿using System.ComponentModel.DataAnnotations;

namespace Business.Objects.Layer.Pocos.Data
{
    public class Post
    {
        [Key]
        public int Id { get; set; }

        public string Title { get; set; }
        public string Content { get; set; }

        public int BlogId { get; set; }
        public virtual Blog Blog { get; set; }
    }
}