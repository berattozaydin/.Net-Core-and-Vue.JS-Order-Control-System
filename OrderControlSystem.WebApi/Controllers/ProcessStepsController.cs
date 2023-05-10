using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.Middleware;
using OrderControlSystem.BLL.Managers;
using OrderControlSystem.BLL.Models;
using OrderControlSystem.BLL.Models.FilterModels;
using OrderControlSystem.DAL;

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ProcessStepsController : ControllerBase
    {
        readonly ProcessStepsManager receiptManager;

        public ProcessStepsController(ProcessStepsManager receiptManager)
        {
            this.receiptManager = receiptManager;
        }

        [HttpPost]
        [LogHandleMiddleware("Reçete Eklendi")]
        public ReturnResult AddProcessSteps(OrderControlSystem.DAL.ProcessSteps item)
        {
            var res = receiptManager.Add(item);
            return res;
        }
        [HttpGet]
        public IActionResult GetProcessSteps([FromQuery] int receiptId)
        {
            var receipt = receiptManager.List(x => x.ProcessStepsId == receiptId);
            return Ok(receipt);
        }
        [HttpGet]
        public IActionResult GetProcessStepssList()
        {
            var list = receiptManager.List();
            return Ok(list);
        }
        [HttpPost]
        public IActionResult ListWithDetail(ReceiptWithFilterModel filterModel)
        {
            var list = receiptManager.ListWithDetail(filterModel);
            return Ok(list);
        }
        [HttpPost]
        [LogHandleMiddleware("Reçete Güncellendi")]
        public ReturnResult UpdateProcessSteps(OrderControlSystem.DAL.ProcessSteps receipt)
        {
            var res = receiptManager.Update(receipt);
            return res;
        }
        [HttpPost]
        [LogHandleMiddleware("Reçete Silindi")]
        public IActionResult DeleteProcessSteps(int processStepsId)
        {
            receiptManager.Delete(processStepsId);
            return Ok("Silindi" + processStepsId);
        }

    }
}
