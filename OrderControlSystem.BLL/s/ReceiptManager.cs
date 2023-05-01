using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Linq;
using AutoMapper;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using OrderControlSystem.DAL;
using OrderControlSystem.DAL.Concrete;
using OrderControlSystem.BLL.Models;
using OrderControlSystem.Core.Models;
using OrderControlSystem.DAL.Models;
using OrderControlSystem.BLL.Models.FilterModels;

namespace OrderControlSystem.BLL.Managers
{
    public class ReceiptManager
    {
        ReceiptRepository receiptRepository;
        TreatmentTypeRepository treatmentTypeRepository;
        private readonly OrderControlContext orderControlContext;
        public ReceiptManager(OrderControlContext orderControlContext, ReceiptRepository receiptRepository,TreatmentTypeRepository treatmentTypeRepository)
        {
            this.receiptRepository = receiptRepository;
            this.treatmentTypeRepository = treatmentTypeRepository;
            this.orderControlContext = orderControlContext;

        }
        public ReturnResult Add(Receipt item)
        {
            
            orderControlContext.Receipts.Add(item);
            if ((orderControlContext.SaveChanges()) >0)
            {
                    return new ReturnResult
                    {
                        success = 1,
                        msg = "Reçete Eklendi."
                    };
            }
            else
            {
                return new ReturnResult
                {
                    success = 0,
                    msg = "Hata. Reçete Eklenemedi"
                };
            }
            
        }

        public void Delete(int receiptId)
        {
            var item = orderControlContext.Receipts.FirstOrDefault(x => x.ReceiptId == receiptId);
          
            receiptRepository.Delete(item);
        }
       
        public  Response<List<Receipt>> List()
        {
            Response<List<Receipt>> response = new();
            response.Value = (from r in receiptRepository.List()
                              join t in treatmentTypeRepository.List() on r.TreatmentTypeId equals t.TreatmentTypeId
                              
                              select new Receipt() {
                                    
                                    TreatmentType = t,
                                    ReceiptId = r.ReceiptId,
                                    Name=r.Name,
                                    Remark = r.Remark
                              }).ToList();
            return response;
        }

        public Response<List<Receipt>> List(Expression<Func<Receipt, bool>> filter)
        {
            Response<List<Receipt>> response = new();
            response.Value = orderControlContext.Receipts.Where(filter).ToList();
            return response;
        }
       
        public Response<List<ReceiptWithDetail>> ListWithDetail(ReceiptWithFilterModel filterModel)
        {
            var query = receiptRepository.ListWithDetail();
            
            query = FilterReceiptWithDetail(filterModel,query);
            query = SortReceiptWithDetail(filterModel, query);
            var list = query.ToList();
            return new Response<List<ReceiptWithDetail>>
            {
                IsSuccess = true,
                Value = list
            };
        }
        private IQueryable<ReceiptWithDetail> SortReceiptWithDetail(ReceiptWithFilterModel filterModel, IQueryable<ReceiptWithDetail> query)
        {
            if (filterModel.SortOrder == 1)
            {
                query = query.OrderBy(x => x.ReceiptId);
            }
            if (filterModel.SortOrder == -1)
            {
                query = query.OrderByDescending(x => x.ReceiptId);
            }
            return query;
        }
            private IQueryable<ReceiptWithDetail> FilterReceiptWithDetail(ReceiptWithFilterModel filterModel, IQueryable<ReceiptWithDetail> query)
        {
            if (filterModel.ReceiptId != null)
            {
                query = query.Where(x => x.ReceiptId == filterModel.ReceiptId);
            }
            if (filterModel.FurnaceName != null)
            {
                query = query.Where(x => x.FurnaceName == filterModel.FurnaceName);
            }
            if (filterModel.TreatmentTypeName != null)
            {
                query = query.Where(x => x.TreatmentTypeName==filterModel.TreatmentTypeName);
            }
            if (filterModel.Name != null)
            {
                query = query.Where(x => x.Name == filterModel.Name);
            }
            return query;
        }
        public ReturnResult Update(Receipt item)
        {
            var receiptUpdate = orderControlContext.Receipts.FirstOrDefault(x=>x.ReceiptId==item.ReceiptId);
            receiptUpdate.TreatmentTypeId = item.TreatmentTypeId;
            receiptUpdate.Remark = item.Remark;
            receiptUpdate.FurnanceId= item.FurnanceId;
            receiptUpdate.Name = item.Name;
            receiptUpdate.ReceiptDetails = item.ReceiptDetails;
            orderControlContext.Receipts.Update(receiptUpdate);
            if (orderControlContext.SaveChanges() > 0)
            {
                    return new ReturnResult
                    {
                        success=1,
                        msg="Reçete Güncellendi."
                    };
            }
            else
            {
                return new ReturnResult
                {
                    success=0,
                    msg="Hata. Sipariş Güncellenemedi."
                };
            }
        }
    }
}
