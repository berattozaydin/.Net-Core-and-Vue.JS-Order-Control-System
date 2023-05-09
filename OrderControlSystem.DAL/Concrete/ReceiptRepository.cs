using Microsoft.EntityFrameworkCore;
using OrderControlSystem.DAL.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;


namespace OrderControlSystem.DAL.Concrete
{
    public class ProcessStepsRepository : GenericRepository<ProcessSteps, OrderControlContext>
    {
        OrderControlContext _context;
        public ProcessStepsRepository(OrderControlContext context) : base(context)
        {
            _context = context;
        }
        public IQueryable<ReceiptWithDetail> ListWithDetail()
        {
            return _object.Select(x => new ReceiptWithDetail
            {
                ProcessStepsId = x.ProcessStepsId,
                Name = x.Name,
                Remark = x.Remark,
                TreatmentTypeId = x.TreatmentTypeId,
                TreatmentTypeName = x.TreatmentType.Name
            });
        }
    }
}
