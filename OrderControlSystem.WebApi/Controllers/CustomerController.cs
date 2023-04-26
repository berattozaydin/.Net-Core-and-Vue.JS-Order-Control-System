using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.HandleMiddleware;
using OrderControlSystem.BLL.Managers;


// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class CustomerController : Controller
    {
        CustomerManager customerManager;
        public CustomerController(CustomerManager customerManager)
        {
            this.customerManager = customerManager;
        }
        [HttpGet]
        public IActionResult GetCustomerList()
        {
            var list = customerManager.List();
            return Ok(list);
        }
        [HttpGet]
        [LogHandleMiddleware("Müşteriler Senkronize Edildi")]
        public async Task<IActionResult> GetCustomerListWithAccounting()
        {
            var list = await customerManager.GetCustomerListWithAccounting();
            return Ok(list);
        }
    }
}

