using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using OrderControlSystem.Core.Models;
using OrderControlSystem.DAL;
using OrderControlSystem.DAL.Concrete;

namespace OrderControlSystem.BLL.Managers
{
    public class ReceiptDetailManager
    {
        ReceiptDetailRepository receiptDetailRepository;

        public ReceiptDetailManager(ReceiptDetailRepository receiptDetailRepository)
        {
            this.receiptDetailRepository = receiptDetailRepository;
        }
        public void Add(ReceiptDetail item)
        {
            receiptDetailRepository.Add(item);
        }

        public void Delete(ReceiptDetail item)
        {
            receiptDetailRepository.Delete(item);
        }

        public ReceiptDetail GetById(int id)
        {
            return receiptDetailRepository.GetById(id);
        }

        public Response<List<ReceiptDetail>> List()
        {
            Response<List<ReceiptDetail>> response = new();
            response.Value=receiptDetailRepository.List();
            return response;
        }

        public Response<List<ReceiptDetail>> List(Expression<Func<ReceiptDetail, bool>> filter)
        {
            Response<List<ReceiptDetail>> response = new();
            response.Value = receiptDetailRepository.List(filter);
            return response;
        }

        public void Update(ReceiptDetail item)
        {
            var receiptDetail = receiptDetailRepository.GetById(item.ReceiptDetailId);
            receiptDetail.ReceiptId = item.ReceiptId;
            receiptDetail.StepNo = item.StepNo;
            receiptDetail.Temperature = item.Temperature;
            receiptDetail.HeatingTime = item.HeatingTime;
            receiptDetailRepository.Update(receiptDetail);
        }
    }
}
