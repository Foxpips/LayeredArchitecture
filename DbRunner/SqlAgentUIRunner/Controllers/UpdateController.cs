using System.Web.Mvc;

using Buy4Now.Three.SqlRunner.Core.Collections;
using Buy4Now.Three.SqlRunner.Core.Runner;

using SqlAgentUIRunner.Infrastructure.Tasks;

namespace SqlAgentUIRunner.Controllers
{
    public class UpdateController : Controller
    {
        private static readonly TaskManager _updateTaskManager = new TaskManager();
        private static string _targetServer;

        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Update(string environmentDdl)
        {
            _updateTaskManager.AddTask(1, () => new SprocRunner(environmentDdl).RunProceduresIntoDatabase());
            _updateTaskManager.RunTasks();
            _targetServer = environmentDdl;
            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult PollProgress()
        {
            return Json(new
            {
                inProgress = _updateTaskManager.TasksInProgress(),
                progressInfo =
                    "<span>Target:" + _targetServer + "</span>"
                    + "<br/><span> Action: Updating" + "</span>"
                    + "<br/><span> Current File:" + SqlCollection.CurrentFile + "</span>"
            });
        }
    }
}