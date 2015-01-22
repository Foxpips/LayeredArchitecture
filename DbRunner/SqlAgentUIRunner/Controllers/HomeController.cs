using System.Web.Mvc;

namespace SqlAgentUIRunner.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Message = "Select an operation";

            return View();
        }

        public ActionResult Comparison()
        {
            ViewBag.Message = "Run Database Diagnostics";

            return RedirectToAction("Index","Comparison");
        }

        public ActionResult Backup()
        {
            ViewBag.Message = "Run Database Diagnostics";

            return RedirectToAction("Index","Backup");
        }

        public ActionResult Update()
        {
            ViewBag.Message = "Run Database Updates";
            return RedirectToAction("Index","Update");
        }
    }
}
