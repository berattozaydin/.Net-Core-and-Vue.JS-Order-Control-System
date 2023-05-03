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
    public class ProcessStepsManager
    {
        ProcessStepsRepository processStepsRepository;
        TreatmentTypeRepository treatmentTypeRepository;
        private readonly OrderControlContext orderControlContext;
        public ProcessStepsManager(OrderControlContext orderControlContext, ProcessStepsRepository receiptRepository,TreatmentTypeRepository treatmentTypeRepository)
        {
            this.processStepsRepository = receiptRepository;
            this.treatmentTypeRepository = treatmentTypeRepository;
            this.orderControlContext = orderControlContext;

        }
        public ReturnResult Add(ProcessSteps item)
        {
            
            orderControlContext.ProcessStepss.Add(item);
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
            var item = orderControlContext.ProcessStepss.FirstOrDefault(x => x.ProcessStepsId == receiptId);
            processStepsRepository.Delete(item);
        }
       
        public  Response<List<ProcessSteps>> List()
        {
            Response<List<ProcessSteps>> response = new();
            response.Value = (from r in processStepsRepository.List()
                              join t in treatmentTypeRepository.List() on r.TreatmentTypeId equals t.TreatmentTypeId
                              
                              select new ProcessSteps() {
                                    
                                    TreatmentType = t,
                                  ProcessStepsId = r.ProcessStepsId,
                                    Name=r.Name,
                                    Remark = r.Remark
                              }).ToList();
            return response;
        }

        public Response<List<ProcessSteps>> List(Expression<Func<ProcessSteps, bool>> filter)
        {
            Response<List<ProcessSteps>> response = new();
            response.Value = orderControlContext.ProcessStepss.Where(filter).ToList();
            return response;
        }
       
        public Response<List<ReceiptWithDetail>> ListWithDetail(ReceiptWithFilterModel filterModel)
        {
            var query = processStepsRepository.ListWithDetail();
            
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
        public ReturnResult Update(ProcessSteps item)
        {
            var receiptUpdate = orderControlContext.ProcessStepss.FirstOrDefault(x=>x.ProcessStepsId == item.ProcessStepsId);
            receiptUpdate.TreatmentTypeId = item.TreatmentTypeId;
            receiptUpdate.Remark = item.Remark;
            receiptUpdate.Name = item.Name;
            receiptUpdate.ProcessStepsDetails = item.ProcessStepsDetails;
            orderControlContext.ProcessStepss.Update(receiptUpdate);
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
