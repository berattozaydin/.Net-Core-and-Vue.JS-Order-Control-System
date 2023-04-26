using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.HandleMiddleware;
using OrderControlSystem.BLL.Managers;
using OrderControlSystem.BLL.Models;
using OrderControlSystem.BLL.Models.FilterModels;
using OrderControlSystem.Core.Models;
using OrderControlSystem.DAL;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]

    public class CustomerOrderController : Controller
    {
        readonly CustomerOrderManager customerOrderManager;
        readonly OrderControlContext tpHetrContext;
        CustomerOrderStatusManager customerOrderStatusManager;
        public CustomerOrderController(CustomerOrderManager customerOrderManager, OrderControlContext tpHetrContext, CustomerOrderStatusManager customerOrderStatusManager)
        {
            this.customerOrderManager = customerOrderManager;
            this.tpHetrContext = tpHetrContext;
            this.customerOrderStatusManager = customerOrderStatusManager;

        }

        [HttpPost]
        public IActionResult GetCustomerOrderList([FromBody] L3TabMenu l3TabMenu)
        {
            var customerOrderList = new Response<List<OrderControlSystem.DAL.CustomerOrder>>();
            if (l3TabMenu.statusId == 0)
            {
                customerOrderList = customerOrderManager.List();
            }
            else
            {
                customerOrderList = customerOrderManager.List(x => x.CustomerOrderStatusId == l3TabMenu.statusId);
            }


            return Ok(customerOrderList);
        }
        [HttpPost]
        public IActionResult ListWithCustomerOrder(CustomerOrderWithDetailFilterModel customerOrderWithDetailModel)
        {
            var list = customerOrderManager.ListWithDetail(customerOrderWithDetailModel);
            return Ok(list);
        }
        [HttpGet]
        public IActionResult GetCustomerOrder([FromQuery] string customerOrderId)
        {

            var getCustomerOrder = customerOrderManager.GetCustomerOrder(customerOrderId);
            return Ok(getCustomerOrder);
        }

        [HttpPost]
        [LogHandleMiddleware("Sipariş Eklendi")]
        public async Task<IActionResult> AddCustomerOrder(CustomerOrder customerOrder)
        {
            var list = await customerOrderManager.AddCustomerOrder(customerOrder);
            return Ok(list);

        }
        [HttpPost]
        [LogHandleMiddleware("Sipariş Güncellendi")]
        public async Task<ReturnResult> UpdateCustomerOrder(CustomerOrder customerOrder)
        {
            var res = await customerOrderManager.UpdateCustomerOrder(customerOrder);
            return res;
        }
        [HttpPost]
        [LogHandleMiddleware("Sipariş Silindi")]
        public async Task<ReturnResult> DeleteCustomerOrder(string customerOrderId)
        {
            var res = tpHetrContext.CustomerOrders.FirstOrDefault(x => x.CustomerOrderId == customerOrderId);
            var result = await customerOrderManager.Delete(res);
            return result;
        }
        [HttpGet]
        public IActionResult GetCustomerOrderStatus()
        {
            var list = customerOrderStatusManager.GetCustomerOrderStatus();
            return Ok(list);

        }
        [HttpGet]
        public IActionResult GetCustomerOrderStatusCount()
        {
            var list = customerOrderStatusManager.GetCustomerOrderStatusCount();
            return Ok(list);
        }
        [HttpGet]
        public string GetCustomerOrderNumber()
        {
            var res = customerOrderManager.GetCustomerOrderNumber();
            return res;
        }
    }
}

