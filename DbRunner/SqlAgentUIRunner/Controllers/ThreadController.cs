using System.Web.Mvc;

using Service.Layer.ScriptRunnerService.Runner;

using SqlAgentUIRunner.Infrastructure.Manager;

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
            _taskManager.AddTask(1, () => new SprocRunner("uatprod").RunProceduresIntoDatabase());
            _taskManager.AddTask(2, () => new ComparisonRunner("uatprod").GenerateSprocComparisonFiles());
            _taskManager.AddTask(3, () => new ComparisonRunner("uatprod").GetMissingProcs());
            _taskManager.AddTask(4, () => new ComparisonRunner("uatprod").GetNewProcs());
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