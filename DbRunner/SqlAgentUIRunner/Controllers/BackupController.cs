using System.Web.Mvc;

using Buy4Now.Three.SqlRunner.Core.Runner;

using SqlAgentUIRunner.Infrastructure.Tasks;

namespace SqlAgentUIRunner.Controllers
{
    public class BackupController : Controller
    {
        private static readonly TaskManager _updateTaskManager = new TaskManager();

        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Backup(string environmentDdl)
        {
            _updateTaskManager.AddTask(1, () => new BackupRunner(environmentDdl).BackUpSprocs());
            _updateTaskManager.RunTasks();
            return RedirectToAction("Index");
        }

    }
}
