using System;

namespace Data.Access.Layer.EntityDomain.Attributes
{
    public class DataParamAttribute : Attribute
    {
        public bool IsOutput { get; set; }
    }
}