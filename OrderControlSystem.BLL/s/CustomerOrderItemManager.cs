using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using AutoMapper;
using System.IO;
using DocumentFormat.OpenXml.Bibliography;
using System.Net.Http;
using System.Security.Policy;
using System.Text;
using OrderControlSystem.DAL;
using OrderControlSystem.DAL.Concrete;
using OrderControlSystem.Core.Models;
using OrderControlSystem.DAL.Models;
using OrderControlSystem.BLL.Models;

namespace OrderControlSystem.BLL.Managers
{
    public class CustomerOrderItemManager
    {
        readonly CustomerOrderItemRepository customerOrderItemRepository;
        readonly MaterialQualityRepository materialQualityRepository;
        readonly TreatmentTypeRepository treatmentTypeRepository;
        readonly OrderControlContext orderControlContext;
        public CustomerOrderItemManager(TreatmentTypeRepository treatmentTypeRepository, MaterialQualityRepository materialQualityRepository, OrderControlContext orderControlContext, CustomerOrderItemRepository customerOrderItemRepository)
        {
            this.customerOrderItemRepository = customerOrderItemRepository;
            this.materialQualityRepository = materialQualityRepository;
            this.treatmentTypeRepository = treatmentTypeRepository;
            this.orderControlContext = orderControlContext;
        }

        public async void Add(CustomerOrderItem item)
        {
            if(item.CustomerOrderItemId==null)
                item.CustomerOrderItemId = Guid.NewGuid().ToString();
            var customerOrder = await orderControlContext.CustomerOrderItems.AddAsync(item);
            await orderControlContext.SaveChangesAsync();
        }

        public async void Delete(string item)
        {
            var deletedCustomerOrderItem =orderControlContext.CustomerOrderItems.FirstOrDefault(x=>x.CustomerOrderItemId==item);
            orderControlContext.CustomerOrderItems.Remove(deletedCustomerOrderItem);
            orderControlContext.SaveChanges();
        }

        public Response<List<CustomerOrderItem>> List()
        {
            Response<List<CustomerOrderItem>> response = new();
            var customerOrderItemList = customerOrderItemRepository.List();
            var materialQuality = materialQualityRepository.List();
            var treatmentType = treatmentTypeRepository.List();
            var customerOrderItemStatus = orderControlContext.CustomerOrderItemStatuses.ToList();
            var customer = orderControlContext.Customers.ToList();
            var list = new List<CustomerOrderItem>();
       
            response.Value = (from coi in customerOrderItemList
                             join maq in materialQuality on coi.MaterialQualityId equals maq.MaterialQualityId
                              join tret in treatmentType on coi.TreatmentTypeId equals tret.TreatmentTypeId
                              join cois in customerOrderItemStatus on coi.CustomerOrderItemStatusId equals cois.CustomerOrderItemStatusId
                              join cu in customer on coi.CustomerId equals cu.CustomerId
                              select coi).ToList();
           
            return response;
        }

        public Response<List<CustomerOrderItemWithDetail>> ListWithDetail(Expression<Func<CustomerOrderItem, bool>> filter)
        {
            Response<List<CustomerOrderItemWithDetail>> response = new();
            var customerOrderItemList = customerOrderItemRepository.List(filter);
            var materialQuality = materialQualityRepository.List();
            var treatmentType = treatmentTypeRepository.List();
            var customerOrderItemStatus = orderControlContext.CustomerOrderItemStatuses.ToList();
            var customer = orderControlContext.Customers.ToList();
            var res = orderControlContext.CustomerOrderItems
                                    .Where(filter)
                                    .Select(coi=>new CustomerOrderItemWithDetail{
                                  CustomerName = coi.Customer.CompanyName,
                                  CustomerOrderItemId=coi.CustomerOrderItemId,
                                  CustomerId=coi.CustomerId,
                                  CustomerOrderItemStatusName=coi.CustomerOrderItemStatus.Name,
                                  CustomerOrderItemStatusId=coi.CustomerOrderItemStatusId,
                                  CustomerOrderId=coi.CustomerOrderId,
                                  DrawingNo=coi.DrawingNo,
                                  Depth=coi.Depth,
                                  Hb=coi.Hb,
                                  Hrc=coi.Hrc,
                                  Height=coi.Height,
                                  Width=coi.Width,
                                  PieceNumber=coi.PieceNumber,
                                  PieceWeight=coi.PieceWeight,
                                  MaterialQualityId=coi.MaterialQualityId,
                                  MaterialQualityName=coi.MaterialQuality.Name,
                                  //MaterialQualityUnknown=coi?.MaterialQualityUnknown,
                                  TreatmentTypeId=coi.TreatmentTypeId,
                                  TreatmentTypeName=coi.TreatmentType.Name,
                                  Remark=coi.Remark,
                                  Name=coi.Name,
                                  CreateDate=coi.CreateDate,
                                  FinishDate=coi.FinishDate,
                                  FilePath=coi.FilePath,
                                  RegistrationDate=coi.RegistrationDate,
                                  RequestDate=coi.RequestDate,
                                  ShippingDate=coi.ShippingDate,
                                  StartDate=coi.StartDate,
                              }).ToList();

            response.Value = res;
            return response;
        }


      
        public void Update(CustomerOrderItem item)
        {
            var customerOrderItem = orderControlContext.CustomerOrderItems.FirstOrDefault(x => x.CustomerOrderItemId == item.CustomerOrderItemId);
            customerOrderItem.CustomerOrderId = item.CustomerOrderId;
            customerOrderItem.CustomerId = item.CustomerId;
            customerOrderItem.CustomerOrderItemId = item.CustomerOrderItemId;
            customerOrderItem.CustomerOrderItemStatusId = item.CustomerOrderItemStatusId;
            customerOrderItem.CreateDate = item.CreateDate;
            customerOrderItem.Name = item.Name;
            customerOrderItem.DrawingNo = item.DrawingNo;
            customerOrderItem.Depth = item.Depth;
            customerOrderItem.FinishDate = item.FinishDate;
            customerOrderItem.Hb = item.Hb;
            customerOrderItem.Height = item.Height;
            customerOrderItem.Hrc = item.Hrc;
            customerOrderItem.MaterialQualityId = item.MaterialQualityId;
            customerOrderItem.MaterialQualityUnknown = item.MaterialQualityUnknown;
            customerOrderItem.PieceNumber = item.PieceNumber;
            customerOrderItem.PieceWeight = item.PieceWeight;
            customerOrderItem.Remark = item.Remark;
            customerOrderItem.RegistrationDate = item.RegistrationDate;
            customerOrderItem.TreatmentTypeId = item.TreatmentTypeId;
            customerOrderItem.RequestDate = item.RequestDate;
            customerOrderItem.ShippingDate = item.ShippingDate;
            orderControlContext.CustomerOrderItems.Update(customerOrderItem);
            orderControlContext.SaveChanges();
        }
        
        public async Task<ReturnResult> UploadCustomerOrderItemFile(UploadFile uploadFile)
        {
            
            
            var extent = Path.GetExtension(uploadFile.Files.FileName);
            var randomName = ($"{Guid.NewGuid()}{extent}");
            var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot//pdfs", randomName);

            using (var stream = new FileStream(path, FileMode.Create))
            {
                await uploadFile.Files.CopyToAsync(stream);
            }
            if (uploadFile.customerOrderItemId != null)
            {
                var item =await orderControlContext.CustomerOrderItems.FirstOrDefaultAsync(x => x.CustomerOrderItemId == uploadFile.customerOrderItemId);
                item.FilePath = path;
                orderControlContext.CustomerOrderItems.Update(item);
                await orderControlContext.SaveChangesAsync();
            }
            else
            {

                return new ReturnResult { success = 0, msg = "Sipariş Alt Kalem Numarası Yok" };
            }
            //UploadFileL4(uploadFile);
            return new ReturnResult { success = 1, msg = "Dosya Yükleme Başarılı" };
        }
        /*private void UploadFileL4(UploadFile uploadFile)
        {
            var publishUrl = new Uri("https:// localhost:5035 /app/api/OrderDetail.php?UploadFile");
            using (var client = new HttpClient())
            {
                var request = new HttpRequestMessage
                {
                    Method = HttpMethod.Get,
                    RequestUri = publishUrl,
                    Content = new MultipartFormDataContent(uploadFile.Files, Encoding.UTF8, "multipart/form-data")
                };
            }
        }*/
       
    }
}

