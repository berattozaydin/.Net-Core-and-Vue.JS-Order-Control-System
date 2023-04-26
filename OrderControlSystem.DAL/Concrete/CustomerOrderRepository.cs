using Microsoft.EntityFrameworkCore;
using OrderControlSystem.DAL.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace OrderControlSystem.DAL.Concrete
{
    public class CustomerOrderRepository : GenericRepository<CustomerOrder, OrderControlContext>
    {

        OrderControlContext _context;
        public CustomerOrderRepository(OrderControlContext context) : base(context)
        {
            _context = context;
        }
        public override List<CustomerOrder> List()
        {
            return _object.Include(co => co.CustomerOrderStatus).ToList();
        }
        public override List<CustomerOrder> List(Expression<Func<CustomerOrder, bool>> filter)
        {
            //Select(co=>new CustomerOrder() { CustomerOrderStatus = co.CustomerOrderStatus,Name=co.Name,Remark=co.Remark,CustomerOrderId=co.CustomerOrderId})
            return _object.Include(co => co.CustomerOrderStatus).Where(filter).ToList();
        }
        public IQueryable<CustomerOrderWithDetail> ListWithDetail()
        {
            return _object.Select(x => new CustomerOrderWithDetail
            {
                CustomerId = x.CustomerId,
                CustomerOrderId = x.CustomerOrderId,
                CustomerOrderStatusId = x.CustomerOrderStatusId,
                Remark = x.Remark,
                OrderNumber = x.OrderNumber,
                Name = x.Name,
                CustomerName = x.Customer.CompanyName,
                CustomerOrderStatusName = x.CustomerOrderStatus.Name,
                CreatedDate = x.CreatedDate
            });
        }

    }
}
