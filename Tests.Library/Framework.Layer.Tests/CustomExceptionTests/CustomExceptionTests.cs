using System.Reflection;

using Core.Library.Exceptions;
using Core.Library.Exceptions.Generic;
using Core.Library.Exceptions.Generic.Args;

using NUnit.Framework;

namespace Tests.Library.Framework.Layer.Tests.CustomExceptionTests
{
    [TestFixture]
    public class CustomExceptionTests
    {
        [Test]
        public void MethodUnderTest_TestedBehavior_ExpectedResult()
        {
            const string errorConnectingToDatabase = "Error connecting to database";
            var exceptionArgs = new DatabaseErrorExceptionArgs(errorConnectingToDatabase);
            var customException = new CustomException<DatabaseErrorExceptionArgs>(exceptionArgs);

            Assert.That(customException.Args.ErrorMessage, Is.EqualTo(errorConnectingToDatabase));
        }

        [Test]
        public void DatabaseErrorExceptionArgs_Test_DatabaseErrorException()
        {
            var exceptionArgs = new DatabaseErrorExceptionArgs("Error");
            exceptionArgs.Handle();
        }

        [Test]
        public void DatabaseErrorExceptionArgs_Message_Test()
        {
            var mappingExceptionArgs = new EntityMappingExceptionArgs("Name");

            Assert.That(mappingExceptionArgs.PropertyName, Is.EqualTo("Name"));

            var item = typeof (EntityMappingExceptionArgs);

            var propertyInfo = item.GetProperty("Message",
                BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);

            var methodInfo = propertyInfo.GetMethod;
            object invoke = methodInfo.Invoke(mappingExceptionArgs, null);

            Assert.That(invoke, Is.EqualTo("Failed to Map entity property to sqlEntityProperty of property: Name"));
        }

        [Test]
        public void EntityMappingExceptionArgs_Handle_Test()
        {
            var args = new EntityMappingExceptionArgs("Name");
            args.Handle();
        }

        [Test]
        public void JsonConvertErrorArgs_Test_Message()
        {
            const string jsonError = "Json Error";
            var args = new JsonConvertErrorArgs(jsonError);
            Assert.That(args.ErrorMessage.Equals(jsonError));
        }

        [Test]
        public void JsonConvertErrorArgs_Test_Handle()
        {
            const string jsonError = "Json Error";
            var args = new JsonConvertErrorArgs(jsonError);

            args.Handle();
        }

        [Test]
        public void TestedBehavior_ExpectedResult()
        {
            const string errorWithCryptography = "Error with cryptography";
            var exceptionArgs = new CryptoServiceExceptionArgs(errorWithCryptography);
            var args = exceptionArgs;
            args.Handle();

            Assert.That(args.ToString().Equals("The cryptographic exception encountered was: " + errorWithCryptography));
        }
    }
}