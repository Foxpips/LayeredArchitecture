using System;

namespace Business.Objects.Layer.Pocos.Data
{
    [Serializable]
    public class Movie
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Rating { get; set; }
    }
}