using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using OrderControlSystem.Core.Models;
using OrderControlSystem.DAL;

namespace OrderControlSystem.BLL.Managers
{
	public class CustomerOrderItemStatusManager
	{
        Response<List<CustomerOrderItemStatus>> response = new();
        OrderControlContext orderControlContext;
        public CustomerOrderItemStatusManager(OrderControlContext orderControlContext)
		{
            this.orderControlContext = orderControlContext;
		}

        public Response<List<CustomerOrderItemStatus>> List()
        {
            var list = orderControlContext.CustomerOrderItemStatuses.ToList();
            response.Value = list;
            return response;
        }

        public Response<List<CustomerOrderItemStatus>> List(Expression<Func<CustomerOrderItemStatus, bool>> filter)
        { 
            var list = orderControlContext.CustomerOrderItemStatuses.Where(filter).ToList();
            response.Value = list;
            return response;
        }
    }
}

