using Microsoft.EntityFrameworkCore;
using OrderControlSystem.BLL;
using OrderControlSystem.BLL.Models;
using OrderControlSystem.Core.Models;
using OrderControlSystem.DAL;
using OrderControlSystem.DAL.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrderControlSystem.BLL.Managers
{
    public class ReportManager
    {
        private readonly CustomerOrderRepository _customerOrderRepository;
        private readonly OrderControlContext orderControlContext;

        public ReportManager(CustomerOrderRepository customerOrderRepository, OrderControlContext orderControlContext)
        {
            _customerOrderRepository = customerOrderRepository;
            orderControlContext = orderControlContext;
        }

        public async Task<Response<byte[]>> GetCustomerReport(string customerOrderItemId)
        {
            var customerOrderItem = orderControlContext.CustomerOrderItems.Include(x => x.Customer).Include(x => x.TreatmentType).FirstOrDefault(x => x.CustomerOrderItemId == customerOrderItemId);

            if (customerOrderItem == null)
            {
                throw new Exception("Gerilim giderme raporu için ilgili sipariş kalemi bulunamadı.");
            }


        

            var excelData = new CustomerReport
            {
                FormDate = DateTime.Now.ToShortDateString(),
                CompanyName = customerOrderItem.Customer?.CompanyName,
                StartDate = customerOrderItem.StartDate?.ToShortDateString(),
                TreatmentTypeName = customerOrderItem.TreatmentType?.Name,
                Name = customerOrderItem.Name,
                PieceNumber = customerOrderItem.PieceNumber,
                PieceWeight = customerOrderItem.PieceWeight,
                Width = customerOrderItem.Width,
                Height = customerOrderItem.Height,
                ShippingDate = customerOrderItem.ShippingDate?.ToShortDateString(),
            };

            var excelFile = Helpers.GetExcelFileFromTemplate("customerReport", excelData);

            return new Response<byte[]>
            {
                IsSuccess = true,
                Value = excelFile
            };
        }
    }
}
