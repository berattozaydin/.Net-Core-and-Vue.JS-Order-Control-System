using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.Middleware;
using OrderControlSystem.BLL.Managers;
using OrderControlSystem.Core.Models;
using OrderControlSystem.DAL;


// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Level4Controller : Controller
    {
        Level4Manager level4Manager;
        public Level4Controller(Level4Manager level4Manager)
        {
            this.level4Manager = level4Manager;

        }
        [HttpGet]
        public async Task<IActionResult> GetCustomerOrder()
        {
            var list = await level4Manager.GetCustomerOrder();
            return Ok(list);
        }
        [HttpGet]
        public async Task<IActionResult> GetCustomerOrderItem(string customerOrderId)
        {
            var list = await level4Manager.GetCustomerOrderItem(customerOrderId);
            return Ok(list);
        }

        [HttpPost]
        [LogHandleMiddleware("Seviye 4 Durumları Güncellendi")]
        public async Task<IActionResult> UpdateL4Status(Level3Tolevel4<CustomerOrder> level3Tolevel4)
        {

            var response = await level4Manager.UpdateL4Status(level3Tolevel4);
            return Ok(response);
        }

        [HttpPost]
        [LogHandleMiddleware("Seviye 4 Güncellendi")]
        public async Task<IActionResult> SetDataToLevel4()
        {
            try
            {
                var result = await level4Manager.SetDataToLevel4CustomerOrder();
                return Ok(result);
            }
            catch (Exception ex)
            {
                return Ok(ex);
            }

        }
    }
}

