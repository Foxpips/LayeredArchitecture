using System.Web.Mvc;

using Business.Logic.Layer.Managers.Tasks;

using Service.Layer.ScriptRunnerService.Runner;

namespace Gui.Layer.Controllers
{
    public class BackupController : Controller
    {
        public static readonly AsyncTaskManager UpdateAsyncTaskManager = new AsyncTaskManager();

        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Backup(string environmentDdl)
        {
            UpdateAsyncTaskManager.AddTask(1,
                () => new BackupRunner(environmentDdl).BackUpSprocs());
            UpdateAsyncTaskManager.RunTasks();
            return RedirectToAction("Index");
        }
    }
}