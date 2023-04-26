using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Linq;
using OrderControlSystem.DAL;
using OrderControlSystem.Core.Models;

namespace OrderControlSystem.BLL.Managers
{
    public class TreatmentTypeManager
    {

        OrderControlContext orderControlContext;
        public TreatmentTypeManager(OrderControlContext orderControlContext)
        {
            this.orderControlContext = orderControlContext;
        }

        public Response<List<TreatmentType>> List()
        {
            Response<List<TreatmentType>> response = new();
            response.Value = orderControlContext.TreatmentTypes.ToList();
            return response;
        }

        public Response<List<TreatmentType>> List(Expression<Func<TreatmentType, bool>> filter)
        {
            Response<List<TreatmentType>> response = new();
            response.Value = orderControlContext.TreatmentTypes.Where(filter).ToList();
            return response;
        }
    }
}

