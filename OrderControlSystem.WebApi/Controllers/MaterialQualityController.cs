using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.Managers;
using OrderControlSystem.BLL.Models;
using OrderControlSystem.DAL;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class MaterialQualityController : Controller
    {
        MaterialQualityManager materialQualityManager;
        public MaterialQualityController(MaterialQualityManager materialQualityManager)
        {
            this.materialQualityManager = materialQualityManager;
        }
        [HttpGet]
        public IActionResult GetMaterialQualityList()
        {
            var list = materialQualityManager.List();
            return Ok(list);
        }
        [HttpGet]
        public IActionResult GetMaterialQuality([FromQuery] int materialQualityId)
        {
            var getMaterialQuality = materialQualityManager.List(x => x.MaterialQualityId == materialQualityId);
            return Ok(getMaterialQuality);

        }
        [HttpPost]
        public ReturnResult AddMaterialQuality(MaterialQuality materialQuality)
        {
            var res = materialQualityManager.Add(materialQuality);

            return res;
        }
        [HttpPost]
        public ReturnResult UpdateMaterialQuality(MaterialQuality materialQuality)
        {
            var res = materialQualityManager.Update(materialQuality);
            return res;
        }
        [HttpPost]
        public IActionResult DeleteMaterialQuality(int materialQualityId)
        {
            materialQualityManager.Delete(materialQualityId);
            return Ok(materialQualityId);
        }
    }
}

