using System;

namespace Framework.Layer.Exceptions.Args
{
    public class EntityMappingExceptionArgsBase : ExceptionArgsBase
    {
        public string PropertyName { get; set; }

        public EntityMappingExceptionArgsBase(string propertyName)
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
            //Send email or do whatever to handle this exception
            Console.WriteLine(Message);
        }
    }
}