using System.Configuration;
using System.Web.Mvc;

using Business.Logic.Layer.Managers.Tasks;

using Service.Layer.ScriptRunnerService.Runner;

namespace SqlAgentUIRunner.Controllers
{
    public class ThreadController : Controller
    {
        private static readonly AsyncTaskManager _asyncTaskManager = new AsyncTaskManager();

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Progress()
        {
            var appSetting = ConfigurationManager.AppSettings["rootDir"];
            _asyncTaskManager.AddTask(1, () => new SprocRunner("uatprod", appSetting).RunProceduresIntoDatabase());
            _asyncTaskManager.AddTask(2,
                () => new ComparisonRunner("uatprod", appSetting).GenerateSprocComparisonFiles());
            _asyncTaskManager.AddTask(3, () => new ComparisonRunner("uatprod", appSetting).GetMissingProcs());
            _asyncTaskManager.AddTask(4, () => new ComparisonRunner("uatprod", appSetting).GetNewProcs());
            _asyncTaskManager.RunTasks();
            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult PollProgress()
        {
            return Json(new
            {
                inProgress = _asyncTaskManager.TasksInProgress()
            });
        }
    }
}