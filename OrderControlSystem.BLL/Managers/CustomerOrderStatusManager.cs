using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using OrderControlSystem.Core.Models;
using OrderControlSystem.DAL;

namespace OrderControlSystem.BLL.Managers
{
	public class CustomerOrderStatusManager
	{
		readonly OrderControlContext orderControlContext;
		public CustomerOrderStatusManager(OrderControlContext orderControlContext)
		{
			this.orderControlContext = orderControlContext;
		}
		public async Task<List<CustomerOrderStatus>> GetCustomerOrderStatus()
		{
			
            var list = await orderControlContext.CustomerOrderStatuses.ToListAsync();

            return list;
		}
        public async Task<Result> GetCustomerOrderStatusCount()
        {
            
            var res10 = orderControlContext.CustomerOrders.Count(x => x.CustomerOrderStatusId == 10);
			var res11 = orderControlContext.CustomerOrders.Count(x => x.CustomerOrderStatusId == 11);
            var res20 = orderControlContext.CustomerOrders.Count(x => x.CustomerOrderStatusId == 20);
            var res21 = orderControlContext.CustomerOrders.Count(x => x.CustomerOrderStatusId == 21);
            var res30 = orderControlContext.CustomerOrders.Count(x => x.CustomerOrderStatusId == 30);
            var res40 = orderControlContext.CustomerOrders.Count(x => x.CustomerOrderStatusId == 40);
            var res50 = orderControlContext.CustomerOrders.Count(x => x.CustomerOrderStatusId == 50);
            var res60 = orderControlContext.CustomerOrders.Count(x => x.CustomerOrderStatusId == 60);
            var counts =new Dictionary<string, int>();
			counts.Add("10",res10);
            counts.Add("11", res11);
            counts.Add("20", res20);
            counts.Add("21", res21);
            counts.Add("30", res30);
            counts.Add("40", res40);
            counts.Add("50", res50);
            counts.Add("60", res60);


            return new Result { Value = counts};
        }
    }
}

