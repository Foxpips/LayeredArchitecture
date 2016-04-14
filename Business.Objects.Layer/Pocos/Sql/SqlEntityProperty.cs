namespace Business.Objects.Layer.Pocos.Sql
{
    public class SqlEntityProperty
    {
        public bool IsOutput { get; set; }
        public string Name { get; private set; }
        public object Value { get; private set; }

        public SqlEntityProperty(string name, object value)
        {
            Value = value;
            Name = name;
        }

        public override string ToString()
        {
            return string.Format("{0} - {1}", Name, Value);
        }
    }
}