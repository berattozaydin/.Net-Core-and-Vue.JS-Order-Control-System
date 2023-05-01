using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System.Linq.Dynamic.Core;
using MoreLinq;
using OrderControlSystem.DAL;
using OrderControlSystem.DAL.Concrete;
using OrderControlSystem.BLL.Models;
using OrderControlSystem.Core.Models;
using OrderControlSystem.DAL.Models;
using OrderControlSystem.BLL.Models.FilterModels;

namespace OrderControlSystem.Managers
{
    public class CustomerOrderManager
    {
        readonly CustomerOrderRepository customerOrderRepository;
        readonly OrderControlContext orderControlContext;
     
        public CustomerOrderManager(OrderControlContext orderControlContext, CustomerOrderRepository customerOrderRepository)
        {
            this.customerOrderRepository = customerOrderRepository;
            this.orderControlContext = orderControlContext;
        }
        public async Task<ReturnResult> UpdateCustomerOrder(CustomerOrder item)
        {
            var response = false;
            var args = new ReturnResult();
            if (item.CustomerOrderId == null)
                item.CustomerOrderId = Guid.NewGuid().ToString();
            var customerOrder = await orderControlContext.CustomerOrders.FirstOrDefaultAsync(x => x.CustomerOrderId == item.CustomerOrderId);
            customerOrder.CustomerOrderId = item.CustomerOrderId;
            customerOrder.CustomerOrderStatusId = item.CustomerOrderStatusId;
            customerOrder.CustomerId = item.CustomerId;
            customerOrder.Name = item.Name;
            customerOrder.OrderNumber = item.OrderNumber;
            customerOrder.Remark = item.Remark;
            customerOrder.UpdatedDate = DateTime.Now;
            
            orderControlContext.CustomerOrders.Update(customerOrder);
            if ((await orderControlContext.SaveChangesAsync()) > 0)
            {
                response = true;
            }
            else
            {
                response = false;
               
            }
            
            if(response == true)
            {
                args = new ReturnResult { success = 1, msg = "Sipariş Güncelleme Başarılı" };
            }
            else
            {
                args = new ReturnResult { success = 0, msg = "Sipariş Güncelleme Başarısız" };
            }
            
            return args;
        }
        public async Task<ReturnResult> AddCustomerOrder(CustomerOrder item)
        {
            bool response = false;
            var args = new ReturnResult();
            if (item.CustomerOrderId == null)
                   item.CustomerOrderId = Guid.NewGuid().ToString();
            item.CustomerOrderStatusId = 11;
            item.CreatedDate = DateTime.Now;
            var result = await orderControlContext.CustomerOrders.AddAsync(item);
            if((await orderControlContext.SaveChangesAsync()) > 0){
                response = true;
            }
            else
            {
                response = false;
                args = new ReturnResult { success=0,msg = "Sipariş Ekleme Başarısız" };
                return args;
            }
            if(response == true)
            {
                
            
                    args = new ReturnResult { success = 1, msg = "Sipariş Ekleme Başarılı" };
             
                }    else
                {
                    args = new ReturnResult { success = 0, msg = "Sipariş Ekleme Başarısız" };

                }
            
            CreateCustomerOrderNumber();
            return args;
        }
        private void CreateCustomerOrderNumber()
        {
            orderControlContext.Database.ExecuteSqlRaw("CALL usp_CreateCustomerOrderNumber");
        }
        public Response<List<CustomerOrderWithDetail>> ListWithDetail(CustomerOrderWithDetailFilterModel filterModel)
        {
           
            var query = customerOrderRepository.ListWithDetail();
            query = FilterCustomerOrderWithDetail(filterModel, query);
            query = SortCustomerOrderFilter(filterModel, query);
            var list = query.Where(x => x.CustomerOrderStatusId == filterModel.ActiveIndexCustomerOrder).ToList();
            var totalRecords = list.Count();
            return new Response<List<CustomerOrderWithDetail>>
            {
                IsSuccess = true,
                Value = list,
                TotalRecords = totalRecords
            };
        }
        private IQueryable<OrderControlSystem.DAL.Models.CustomerOrderWithDetail> SortCustomerOrderFilter(CustomerOrderWithDetailFilterModel filterModel, IQueryable<OrderControlSystem.DAL.Models.CustomerOrderWithDetail> query)
        {
            if (filterModel.SortOrder == 1)
            {
                query = query.OrderBy(x => x.CreatedDate);
            }
            if (filterModel.SortOrder == -1)
            {
                query = query.OrderByDescending(x => x.CreatedDate);
            }
            return query;
        }
        private IQueryable<CustomerOrderWithDetail> FilterCustomerOrderWithDetail(CustomerOrderWithDetailFilterModel filterModel, IQueryable<OrderControlSystem.DAL.Models.CustomerOrderWithDetail> query)
        {
            if (filterModel.CustomerOrderId != null)
            {
                query = query.Where(x => x.CustomerOrderId == filterModel.CustomerOrderId);
            }
            if (filterModel.CustomerId != null)
            {
                query = query.Where(x => x.CustomerId == filterModel.CustomerId);
            }
            if (filterModel.OrderNumber != null)
            {
                query = query.Where(x => x.OrderNumber == filterModel.OrderNumber);
            }
            if (filterModel.Name != null)
            {
                query = query.Where(x => x.Name == filterModel.Name);
            }
            if (filterModel.CustomerName != null)
            {
                query = query.Where(x => x.CustomerName == filterModel.CustomerName);
            }
            return query;
        }
        public async Task<ReturnResult> Delete(CustomerOrder item)
        {
            var deleteCustomerOrder = orderControlContext.CustomerOrders.FirstOrDefault(x => x.CustomerOrderId == item.CustomerOrderId);
            orderControlContext.CustomerOrders.Remove(deleteCustomerOrder);
            if (orderControlContext.SaveChanges() > 0)
            {
                
                return new ReturnResult { success=1,msg="Sipariş Silindi" };
            }
            else
            {
                return new ReturnResult
                {
                    success = 0,
                    msg = "Hata. Sipariş Silinemedi"
                };
            }
           
        }
        public Response<List<CustomerOrder>> List()
        {
            Response<List<CustomerOrder>> response = new();
            var customerOrders = customerOrderRepository.List();
            var customerOrderStatus = orderControlContext.CustomerOrderStatuses.ToList();
            
            var customer = orderControlContext.Customers.ToList();
            response.Value = (from co in customerOrders

                              join cos in customerOrderStatus on co.CustomerOrderStatusId equals cos.CustomerOrderStatusId
                              join cu in customer on co.CustomerId equals cu.CustomerId select co).ToList();
            return response;
        }
        public Response<List<CustomerOrder>> List(Expression<Func<CustomerOrder, bool>> filter)
        {
            Response<List<CustomerOrder>> response = new();
            var customerOrders = customerOrderRepository.List(filter);
            var customerOrderStatus = orderControlContext.CustomerOrderStatuses.ToList();
            var customer = orderControlContext.Customers.ToList();
            if(customerOrders == null)
            {
                return new Response<List<CustomerOrder>>
                {
                    IsSuccess = false,
                    msg = "  Hata. Sipariş Bulunamadı",
                    
                };
            }
        
            foreach (var co in customerOrders)
            {
                co.CustomerOrderItems = orderControlContext.CustomerOrderItems
                    .Where(x => x.CustomerOrderId == co.CustomerOrderId && x!=null)
                    .Select(x => new CustomerOrderItem
                    {
                        CustomerOrderId = x.CustomerOrderId,
                        CustomerOrderItemStatusName = x.CustomerOrderItemStatus.Name,
                        CustomerId = x.CustomerId,
                        CustomerOrderItemId = x.CustomerOrderItemId,
                        CustomerOrderItemStatusId = x.CustomerOrderItemStatusId,
                        MaterialQualityName = x.MaterialQuality.Name,
                        TreatmentTypeName = x.TreatmentType.Name,
                        TreatmentTypeId = x.TreatmentTypeId,
                        CreateDate = x.CreateDate,
                        DrawingNo = x.DrawingNo,
                        CustomerCompanyName = x.Customer.CompanyName,
                        PieceNumber = x.PieceNumber,
                        PieceWeight = x.PieceWeight,
                        RegistrationDate = x.RegistrationDate,
                        Name = x.Name,
                        MaterialQualityId = x.MaterialQualityId,
                        Hb = x.Hb,
                        Hrc = x.Hrc

                    }).ToList();
                    

            }
            response.Value = (from co in customerOrders
                              join cos in customerOrderStatus on co.CustomerOrderStatusId equals cos.CustomerOrderStatusId
                              join cu in customer on co.CustomerId equals cu.CustomerId
                              select co).ToList();
            return response;
        }
        public async Task<Response<CustomerOrder>> GetCustomerOrder(string customerOrderId)
        {
            Response<CustomerOrder> response = new();
            var customerOrders = await orderControlContext.CustomerOrders
                .FirstOrDefaultAsync(x=>x.CustomerOrderId == customerOrderId);
            customerOrders.CustomerOrderItems = orderControlContext.CustomerOrderItems
                    .Select(x => new CustomerOrderItem
                    {
                        MaterialQuality = x.MaterialQuality,
                        TreatmentType = x.TreatmentType,
                        CustomerOrderItemStatus = x.CustomerOrderItemStatus,
                        Customer = x.Customer,
                        MaterialQualityId = x.MaterialQualityId,
                        CustomerOrderItemStatusId = x.CustomerOrderItemStatusId,
                        CustomerId = x.CustomerId,
                        CreateDate = x.CreateDate,
                        TreatmentTypeId = x.TreatmentTypeId,
                        DrawingNo = x.DrawingNo,
                        Depth = x.Depth,
                        ShippingDate = x.ShippingDate,
                        StartDate = x.StartDate,
                        FinishDate = x.FinishDate,
                        RegistrationDate = x.RegistrationDate,
                        Hb = x.Hb,
                        Hrc = x.Hrc,
                        PieceNumber = x.PieceNumber,
                        PieceWeight = x.PieceWeight,
                        Name = x.Name,
                        Remark = x.Remark,
                        Width = x.Width,
                    })
                    .ToList();
            response.Value = customerOrders; 
            return response;
        }
       public string GetCustomerOrderNumber()
        {
            var res = orderControlContext.CustomerOrderNumberDto.OrderByDescending(x => x.CustomerOrderNumberCounter).Select(x => x.CustomerOrderNumberCreated).First();
            return res;
        }
        
    }
}