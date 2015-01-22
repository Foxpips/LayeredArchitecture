using System;

namespace Business.Logic.Layer.Pocos
{
    [Serializable]
    public class Movie
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Rating { get; set; }
    }

    [Serializable]
    public class Movie2
    {
        public int Id;
        public string Name;
        public int Rating;
    }
}