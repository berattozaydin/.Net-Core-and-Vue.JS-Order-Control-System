using Microsoft.AspNetCore.Authorization;
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
    [AllowAnonymous]
    public class CustomerOrderItemController : Controller
    {

        CustomerOrderItemManager customerOrderItemManager;
        CustomerOrderItemStatusManager customerOrderItemStatusManager;
        public IWebHostEnvironment webHostEnvironment;
        public CustomerOrderItemController(CustomerOrderItemManager customerOrderItemManager, CustomerOrderItemStatusManager customerOrderItemStatusManager, IWebHostEnvironment webHostEnvironment)
        {
            this.customerOrderItemManager = customerOrderItemManager;
            this.customerOrderItemStatusManager = customerOrderItemStatusManager;
            this.webHostEnvironment = webHostEnvironment;
        }

        [HttpPost]
        [LogHandleMiddleware("Sipariş Alt Kalemi Eklendi")]
        public IActionResult AddCustomerOrderItem(CustomerOrderItem customerOrderItem)
        {
            customerOrderItemManager.Add(customerOrderItem);
            return Ok(customerOrderItem);
        }

        [HttpGet]
        public IActionResult GetCustomerOrderItem()
        {
            var customerOrderItem = customerOrderItemManager.List();
            return Ok(customerOrderItem);
        }

        [HttpGet]
        public IActionResult GetCustomerOrderItemList(string customerOrderId)
        {
            var customerOrderItemList = customerOrderItemManager.ListWithDetail(x => x.CustomerOrderId == customerOrderId);
            return Ok(customerOrderItemList);
        }
        [HttpPost]
        [LogHandleMiddleware("Sipariş Alt Kalemi Silindi")]
        public IActionResult DeleteCustomerOrderItem(string customerOrderItemId)
        {
            customerOrderItemManager.Delete(customerOrderItemId);
            return Ok(customerOrderItemId);
        }
        [HttpPost]
        [LogHandleMiddleware("Sipariş Alt Kalemi Güncellendi")]
        public IActionResult UpdateCustomerOrderItem(CustomerOrderItem customerOrderItem)
        {

            customerOrderItemManager.Update(customerOrderItem);
            return Ok(customerOrderItem);
        }
        [HttpGet]
        public IActionResult GetCustomerOrderItemStatus()
        {
            var list = customerOrderItemStatusManager.List();
            return Ok(list);
        }

        [HttpPost]
        public async Task<IActionResult> UploadFile([FromForm] UploadFile uploadFile)
        {
            var customerOrderItemResult = await customerOrderItemManager.UploadCustomerOrderItemFile(uploadFile);
            return Ok(customerOrderItemResult);
        }

    }
}

