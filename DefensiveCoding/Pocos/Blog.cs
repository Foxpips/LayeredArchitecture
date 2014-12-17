﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Business.Logic.Layer.Pocos
{
    public class Blog
    {
        public Blog()
        {
            Posts = new List<Post>();
        }

        [Key]
        public int Id { get; set; }

        public string Name { get; set; }

        public List<Post> Posts { get; set; }

        public override string ToString()
        {
            return String.Format("Id:{0}, Name:{1}", Id, Name);
        }
    }
}