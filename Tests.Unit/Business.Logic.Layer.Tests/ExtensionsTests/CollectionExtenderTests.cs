﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Linq;
using Business.Logic.Layer.Extensions;
using NUnit.Framework;

namespace Tests.Unit.Business.Logic.Layer.Tests.ExtensionsTests
{
    public class CollectionExtenderTests
    {
        [Test]
        public static void AddRange_KeyValuePair_Test()
        {
            var dictionary = new Dictionary<int, string>();

            var collection2 = new List<KeyValuePair<int, string>>
            {
                new KeyValuePair<int, string>(1, "test")
            };

            dictionary.AddRange(collection2);

            Assert.That(dictionary.ContainsKey(1));
            Assert.That(dictionary.ContainsValue("test"));
        }

        [Test]
        public static void AddRange_ICollection_Test()
        {
            var collection1 = new Collection<string>();

            var collection2 = new LinkedList<string>();
            collection2.AddFirst("Hello");

            collection1.AddRange(collection2);

            Assert.That(collection1.Contains("Hello"), Is.True);
        }

        [Test]
        public void ForEach_IEnumerable_Test()
        {
            var list = new List<string>();
            GetFakeEnumerable().ForEach(item => Console.WriteLine("Adding to list: " + item));
            GetFakeEnumerable().ForEach(list.Add);

            Assert.That(list.Contains("item 5"));
        }

        private static IEnumerable<string> GetFakeEnumerable()
        {
            for (var i = 1; i <= 5; i++)
            {
                yield return string.Concat("item ", i.ToString(CultureInfo.InvariantCulture));
            }
        }

        [Test]
        public void SortSelf_ICollection_Test()
        {
            const string item1 = "A";
            const string item2 = "B";

            //Add B First
            var list = new List<string> {item2, item1};
            
            Console.WriteLine("Unsorted");
            list.ForEach(Console.WriteLine);
            
            Assert.AreSame(list.SortSelf().First(), item1);
            
            Console.WriteLine("Sorted"); 
            list.ForEach(Console.WriteLine);
        }
    }
}