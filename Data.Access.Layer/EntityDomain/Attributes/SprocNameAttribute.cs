using System;

namespace Data.Access.Layer.EntityDomain.Attributes
{
    public class SprocNameAttribute : Attribute
    {
        public String SprocName { get; set; }

        public SprocNameAttribute(string moneycardStorecustomer)
        {
            SprocName = moneycardStorecustomer;
        }
    }
}