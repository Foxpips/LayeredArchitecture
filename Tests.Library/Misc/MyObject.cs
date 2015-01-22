using System;
using System.Runtime.Serialization;
using System.Security.Permissions;

namespace Tests.Library.Misc
{
    [Serializable]
    public class MyObject : ISerializable
    {
        public int _n1;
        public int _n2;
        public String _str;

        public MyObject()
        {
        }

        protected MyObject(SerializationInfo info, StreamingContext context)
        {
            _n1 = info.GetInt32("i");
            _n2 = info.GetInt32("j");
            _str = info.GetString("k");
        }
        [SecurityPermission(SecurityAction.Demand,
            SerializationFormatter = true)]

        public virtual void GetObjectData(SerializationInfo info, StreamingContext context)
        {
            info.AddValue("i", _n1);
            info.AddValue("j", _n2);
            info.AddValue("k", _str);
        }
    }
}