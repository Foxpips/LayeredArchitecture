using System.Configuration;
using System.Web.Mvc;

using Business.Logic.Layer.Managers.Tasks;

using Service.Layer.ScriptRunnerService.Runner;

namespace SqlAgentUIRunner.Controllers
{
    public class ComparisonController : Controller
    {
        private static readonly AsyncTaskManager _updateAsyncTaskManager = new AsyncTaskManager();

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Compare(string environmentDdl)
        {
            _updateAsyncTaskManager.AddTask(1,
                () =>
                    new ComparisonRunner(environmentDdl, ConfigurationManager.AppSettings["rootDir"])
                        .GenerateSprocComparisonFiles());
            _updateAsyncTaskManager.RunTasks();
            return RedirectToAction("Index");
        }
    }
}