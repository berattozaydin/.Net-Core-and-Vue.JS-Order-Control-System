using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.HandleMiddleware;
using OrderControlSystem.BLL.Managers;
using OrderControlSystem.DAL;

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ReceiptDetailController : ControllerBase
    {
        ReceiptDetailManager receiptDetailManager;
        public ReceiptDetailController(ReceiptDetailManager receiptDetailManager)
        {
            this.receiptDetailManager = receiptDetailManager;
        }

        [HttpPost]
        [LogHandleMiddleware("Reçete Alt Kalemi Eklendi")]
        public IActionResult AddReceiptDetail(ReceiptDetail item)
        {
            try
            {
                receiptDetailManager.Add(item);
                return Ok(true);
            }
            catch (Exception ex)
            {
                return Ok(ex.Message);
            }
        }
        [HttpGet]
        public IActionResult GetReceiptDetails([FromQuery] int receiptId)
        {
            try
            {
                return Ok(receiptDetailManager.List(x => x.ReceiptId == receiptId));
            }
            catch (Exception ex)
            {
                return Ok(ex);
            }
        }
        [HttpPost]
        [LogHandleMiddleware("Reçete Alt Kalemi Silindi")]
        public IActionResult DeleteReceiptDetail(int receiptDetailId)
        {
            try
            {
                var receiptDetail = receiptDetailManager.GetById(receiptDetailId);
                receiptDetailManager.Delete(receiptDetail);
                return Ok("Silindi");
            }
            catch (Exception ex)
            {
                return Ok(ex);
            }
        }
        [HttpPost]
        [LogHandleMiddleware("Reçete Alt Kalemi Güncellendi")]
        public IActionResult UpdateReceiptDetail(ReceiptDetail receiptDetail)
        {
            receiptDetailManager.Update(receiptDetail);
            return Ok(receiptDetail);
        }
    }
}