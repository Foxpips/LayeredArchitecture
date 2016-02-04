using Business.Objects.Layer.Interfaces.AutoMapper;
using Business.Objects.Layer.Models.TaskRunner;

using Dependency.Resolver.Loaders;

using Framework.Layer.Loaders.Mapping;

using Gui.Layer.Controllers;

using NUnit.Framework;

namespace Tests.Unit.Dependency.Resolver.Tests
{
    public class StructureMapMvcTests
    {
        [SetUp]
        public void SetUp()
        {
            AutoMapperLoader.LoadAllMappings(typeof (IMapCustom).Assembly.ExportedTypes);
        }

        [Test]
        public void ResolveController_UsingDependencyManager_GetType()
        {
            var container = new DependencyManager().ConfigureStartupDependencies();

            var messageBusController = container.GetInstance<MessageBusController>();
            messageBusController.SendMessage("HelloWorldCommand",
                new TaskRunnerPropertyModel {Name = "1", Description = "Text", Value = "Hello"},
                new TaskRunnerPropertyModel {Name = "2", Description = "Count", Value = "1123"});
        }
    }
}