using System.Web.Mvc;

using Service.Layer.ScriptRunnerService.Runner;

using SqlAgentUIRunner.Infrastructure.Manager;

namespace SqlAgentUIRunner.Controllers
{
    public class BackupController : Controller
    {
        public static readonly TaskManager UpdateTaskManager = new TaskManager();

        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Backup(string environmentDdl)
        {
            UpdateTaskManager.AddTask(1,
                () => new BackupRunner(environmentDdl).BackUpSprocs());
            UpdateTaskManager.RunTasks();
            return RedirectToAction("Index");
        }
    }
}