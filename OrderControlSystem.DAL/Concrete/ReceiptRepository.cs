using Microsoft.EntityFrameworkCore;
using OrderControlSystem.DAL.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;


namespace OrderControlSystem.DAL.Concrete
{
    public class ReceiptRepository : GenericRepository<Receipt, OrderControlContext>
    {
        OrderControlContext _context;
        public ReceiptRepository(OrderControlContext context) : base(context)
        {
            _context = context;
        }
        public override List<Receipt> List()
        {
            return _object.Include(re => re.ReceiptDetails).ToList();
        }
        public override List<Receipt> List(Expression<Func<Receipt, bool>> filter)
        {
            //Select(co=>new CustomerOrder() { CustomerOrderStatus = co.CustomerOrderStatus,Name=co.Name,Remark=co.Remark,CustomerOrderId=co.CustomerOrderId})
            return _object.Include(re => re.ReceiptDetails).Where(filter).ToList();
        }
        public IQueryable<ReceiptWithDetail> ListWithDetail()
        {
            return _object.Select(x => new ReceiptWithDetail
            {
                ReceiptId = x.ReceiptId,
                Name = x.Name,
                Remark = x.Remark,
                FurnanceId = x.FurnanceId,
                TreatmentTypeId = x.TreatmentTypeId,
                FurnaceName = x.Furnance.Name,
                TreatmentTypeName = x.TreatmentType.Name
            });
        }
    }
}
