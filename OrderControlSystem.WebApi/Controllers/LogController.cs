using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.Managers;

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class LogController : Controller
    {
        LogManager logManager;
        public LogController(LogManager logManager)
        {
            this.logManager = logManager;
        }
        [HttpGet]
        public async Task<IActionResult> FetchLogData()
        {
            var list = await logManager.FetchLogData();
            return Ok(list);
        }
    }
}

