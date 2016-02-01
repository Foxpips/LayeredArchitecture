using System;

using Business.Logic.Layer.Helpers;
using Business.Objects.Layer.Exceptions.Generic;
using Business.Objects.Layer.Exceptions.Generic.Args;
using Business.Objects.Layer.Interfaces.Execution;
using Dependency.Resolver.Loaders;

using NUnit.Framework;

namespace Tests.Unit.Dependency.Resolver.Tests
{
    public class SafeExecutionTests
    {
        [Test]
        public void ResolveSafeExecutionHelper_FromStartupDependencies_DefinedinBootstrapperRegistries()
        {
            using (
                var safeExecutionHelper =
                    new DependencyManager().ConfigureStartupDependencies(ContainerType.Nested)
                        .GetInstance<SafeExecutionHelper>())
            {
                Assert.Throws<CustomException<ResolveSafeExecutionHelperTestExceptionArgs>>(
                    () => safeExecutionHelper.ExecuteSafely<Exception>(ExceptionPolicy.RethrowException, () =>
                    {
                        Console.WriteLine("Hello");
                        throw new Exception();
                    }, (ex, log) =>
                    {
                        log.Error("There was an error, it has been logged : \n" + ex.Message);
                        throw new CustomException<ResolveSafeExecutionHelperTestExceptionArgs>(
                            new ResolveSafeExecutionHelperTestExceptionArgs());
                    }));

                safeExecutionHelper.ExecuteSafely<NullReferenceException>(ExceptionPolicy.SwallowException,
                    () =>
                    {
                        Console.WriteLine("");
                        throw new NullReferenceException();
                    },
                    (ex, log) => log.Error(ex.Message));
            }
        }
    }
}