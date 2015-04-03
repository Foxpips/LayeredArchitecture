using System.Configuration;
using System.Web.Mvc;

using Business.Logic.Layer.Managers.Tasks;

using Service.Layer.ScriptRunnerService.Collections;
using Service.Layer.ScriptRunnerService.Runner;

namespace SqlAgentUIRunner.Controllers
{
    public class UpdateController : Controller
    {
        private static readonly AsyncTaskManager _updateAsyncTaskManager = new AsyncTaskManager();
        private static string _targetServer;

        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Update(string environmentDdl)
        {
            _updateAsyncTaskManager.AddTask(1,
                () =>
                    new SprocRunner(environmentDdl, ConfigurationManager.AppSettings["rootDir"])
                        .RunProceduresIntoDatabase());
            _updateAsyncTaskManager.RunTasks();
            _targetServer = environmentDdl;
            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult PollProgress()
        {
            return Json(new
            {
                inProgress = _updateAsyncTaskManager.TasksInProgress(),
                progressInfo =
                    "<span>Target:" + _targetServer + "</span>"
                    + "<br/><span> Action: Updating" + "</span>"
                    + "<br/><span> Current File:" + SqlCollection.CurrentFile + "</span>"
            });
        }
    }
}