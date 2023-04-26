using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.Managers;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class TreatmentTypeController : Controller
    {

        TreatmentTypeManager treatmentTypeManager;
        public TreatmentTypeController(TreatmentTypeManager treatmentTypeManager)
        {
            this.treatmentTypeManager = treatmentTypeManager;
        }
        [HttpGet]
        public IActionResult GetTreatmentTypeList()
        {
            var list = treatmentTypeManager.List();
            return Ok(list);
        }
    }
}

