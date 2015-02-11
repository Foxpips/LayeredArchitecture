using System.Configuration;
using System.Web.Mvc;

using Business.Logic.Layer.Managers.Tasks;

using Service.Layer.ScriptRunnerService.Runner;

namespace SqlAgentUIRunner.Controllers
{
    public class ComparisonController : Controller
    {
        private static readonly TaskManager _updateTaskManager = new TaskManager();
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Compare(string environmentDdl)
        {
            _updateTaskManager.AddTask(1, () => new ComparisonRunner(environmentDdl, ConfigurationManager.AppSettings["rootDir"]).GenerateSprocComparisonFiles());
            _updateTaskManager.RunTasks();
            return RedirectToAction("Index");
        }
    }
}
