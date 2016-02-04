using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Business.Logic.Layer.Extensions
{
    public static class CollectionExtender
    {
        public static void ForEach<TItem>(this IEnumerable<TItem> enumerable, Action<TItem> work)
        {
            foreach (var item in enumerable)
            {
                work(item);
            }
        }

        public static void AddRange<TItem>(this ICollection<TItem> collection1, ICollection<TItem> collection2)
        {
            foreach (var item in collection2)
            {
                collection1.Add(item);
            }
        }

        public static void AddRange<TKey, TValue>(this ICollection<KeyValuePair<TKey, TValue>> collection1, ICollection<KeyValuePair<TKey, TValue>> collection2)
        {
            foreach (var item in collection2)
            {
                collection1.Add(new KeyValuePair<TKey, TValue>(item.Key, item.Value));
            }
        }

        public static ICollection<T> SortSelf<T>(this ICollection<T> collection) where T : IComparable<T>
        {
            var array = collection.ToArray();
            Array.Sort(array);

            collection.Clear();
            collection.AddRange(array);

            return collection;
        }

        public static byte[] ToByteArray(this string content)
        {
            return Encoding.ASCII.GetBytes(content);
        }
    }
}