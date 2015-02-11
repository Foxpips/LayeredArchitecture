using System.Configuration;
using System.Web.Mvc;

using Business.Logic.Layer.Managers.Tasks;

using Service.Layer.ScriptRunnerService.Runner;

namespace SqlAgentUIRunner.Controllers
{
    public class ThreadController : Controller
    {
        private static readonly TaskManager _taskManager = new TaskManager();

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Progress()
        {
            var appSetting = ConfigurationManager.AppSettings["rootDir"];
            _taskManager.AddTask(1, () => new SprocRunner("uatprod", appSetting).RunProceduresIntoDatabase());
            _taskManager.AddTask(2, () => new ComparisonRunner("uatprod", appSetting).GenerateSprocComparisonFiles());
            _taskManager.AddTask(3, () => new ComparisonRunner("uatprod", appSetting).GetMissingProcs());
            _taskManager.AddTask(4, () => new ComparisonRunner("uatprod", appSetting).GetNewProcs());
            _taskManager.RunTasks();
            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult PollProgress()
        {
            return Json(new
            {
                inProgress = _taskManager.TasksInProgress()
            });
        }
    }
}