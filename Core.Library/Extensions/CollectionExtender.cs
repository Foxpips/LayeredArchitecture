using System;
using System.Collections.Generic;

namespace Core.Library.Extensions
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

        public static void AddRange<TItem>(ICollection<TItem> collection1, ICollection<TItem> collection2)
        {
            foreach (var item in collection2)
            {
                collection1.Add(item);
            }
        }

        public static void AddRange<TKey, TValue>(
            this ICollection<KeyValuePair<TKey, TValue>> collection1,
            ICollection<KeyValuePair<TKey, TValue>> collection2)
        {
            foreach (var item in collection2)
            {
                collection1.Add(new KeyValuePair<TKey, TValue>(item.Key, item.Value));
            }
        }
    }
}