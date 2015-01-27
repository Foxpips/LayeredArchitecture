﻿using System.Web.Mvc;

using Service.Layer.ScriptRunnerService.Runner;

using SqlAgentUIRunner.Infrastructure.Manager;

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
            _updateTaskManager.AddTask(1, () => new ComparisonRunner(environmentDdl).GenerateSprocComparisonFiles());
            _updateTaskManager.RunTasks();
            return RedirectToAction("Index");
        }
    }
}
