using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.Managers;

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ReportController : Controller
    {
        private readonly ReportManager _reportManager;

        public ReportController(ReportManager reportManager)
        {
            _reportManager = reportManager;
        }

        [HttpGet]
        public async Task<IActionResult> GetCustomerReport(string customerOrderItemId)
        {
            var res = await _reportManager.GetCustomerReport(customerOrderItemId);
            return Ok(res);
        }

    }
}

