using System;
using System.Collections.Generic;

using Business.Logic.Layer.Pocos;
using Business.Logic.Layer.Pocos.Data;

using NUnit.Framework;

namespace Tests.Library.Business.Logic.Layer
{
    [TestFixture]
    public class BlogTests
    {
        [Test]
        public void Blog_Instantiation_Test()
        {
            var blog = new Blog
            {
                Id = 1,
                Name = "MyBlog",
                Posts = new List<Post>
                {
                    new Post
                    {
                        Blog = new Blog(),
                        Id = 10,
                        BlogId = 20,
                        Content = "Content Goes Here",
                        Title = "Title"
                    }
                }
            };

            Assert.That(blog.Posts.Count > 0, Is.True);
            Assert.That(blog.Id == 1, Is.True);
            Assert.That(blog.Name.Equals("MyBlog", StringComparison.OrdinalIgnoreCase));

            Assert.That(blog.ToString(), Is.EqualTo("Id:1, Name:MyBlog"));
        }
    }
}