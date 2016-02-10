using System;
using System.Collections.Generic;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;

namespace Business.Logic.Layer.Helpers.ClassBuilder
{
    public class ClassBuilder
    {
        public void BuildItem(string assemblyName)
        {

            IEnumerable<CustomAttributeBuilder> assemblyAttributes = new List<CustomAttributeBuilder>();
            AssemblyBuilder assemblyBuilder = Thread.GetDomain().DefineDynamicAssembly(new AssemblyName(assemblyName), AssemblyBuilderAccess.Run, assemblyAttributes);
            ModuleBuilder moduleBuilder = assemblyBuilder.DefineDynamicModule("ModuleName");
            TypeBuilder typeBuilder = moduleBuilder.DefineType("MyNamespace.TypeName", TypeAttributes.Public);

            typeBuilder.DefineDefaultConstructor(MethodAttributes.Public);

            // Add a method
            var newMethod = typeBuilder.DefineMethod("MethodName", MethodAttributes.Public);
            ILGenerator ilGen = newMethod.GetILGenerator();

            // Create IL code for the method
            ilGen.Emit(new OpCode());

            // Create the type itself
            Type newType = typeBuilder.CreateType();
        }
    }
}