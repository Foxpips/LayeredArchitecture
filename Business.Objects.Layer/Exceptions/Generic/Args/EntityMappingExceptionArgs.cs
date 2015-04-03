using System;

namespace Business.Objects.Layer.Exceptions.Generic.Args
{
    public class EntityMappingExceptionArgs : ExceptionArgsBase
    {
        public string PropertyName { get; set; }

        public EntityMappingExceptionArgs(string propertyName)
        {
            PropertyName = propertyName;
        }

        protected override string Message
        {
            get
            {
                return String.Format("Failed to Map entity property to sqlEntityProperty of property: {0}", PropertyName);
            }
        }

        public override void Handle()
        {
            Console.WriteLine(Message);
        }
    }
}