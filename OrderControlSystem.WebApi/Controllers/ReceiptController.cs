using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.HandleMiddleware;
using OrderControlSystem.BLL.Managers;
using OrderControlSystem.BLL.Models;
using OrderControlSystem.BLL.Models.FilterModels;
using OrderControlSystem.DAL;

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ReceiptController : ControllerBase
    {
        readonly ProcessStepsManager receiptManager;

        public ReceiptController(ProcessStepsManager receiptManager)
        {
            this.receiptManager = receiptManager;
        }

        [HttpPost]
        [LogHandleMiddleware("Reçete Eklendi")]
        public ReturnResult AddReceipt(ProcessSteps item)
        {
            var res = receiptManager.Add(item);
            return res;
        }
        [HttpGet]
        public IActionResult GetReceipt([FromQuery] int receiptId)
        {
            var receipt = receiptManager.List(x => x.ProcessStepsId == receiptId);
            return Ok(receipt);
        }
        [HttpGet]
        public IActionResult GetReceiptList()
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
        public ReturnResult UpdateReceipt(ProcessSteps receipt)
        {
            var res = receiptManager.Update(receipt);
            return res;
        }
        [HttpPost]
        [LogHandleMiddleware("Reçete Silindi")]
        public IActionResult DeleteReceipt(int receiptId)
        {
            receiptManager.Delete(receiptId);
            return Ok("Silindi" + receiptId);
        }

    }
}
