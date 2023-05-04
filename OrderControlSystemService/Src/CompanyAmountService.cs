using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using OrderControlSystem.Core.Types;
using OrderControlSystem.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrderControlSystemService.Src
{
    public class CompanyAmountService
    {
        
        CancellationToken cancellationToken;
        public CompanyAmountService(CancellationToken cancellationToken)
        {
            this.cancellationToken = cancellationToken;
            
        }
        public async Task StartAsnyc(CancellationToken cancellationToken)
        {
            while(!cancellationToken.IsCancellationRequested)
            {
                ShoppingCart_CallBack();
                await Task.Delay(2000);
            }
        }
        public async void ShoppingCart_CallBack()
        {
            var orderControlContext = new OrderControlContext();
            var customerOrderItemList = await orderControlContext.CustomerOrderItems.Where(x => x.CustomerOrderItemStatusId == (int)CustomerOrderItemStatusId.PaketlemeAsamasinda).ToArrayAsync();
            int itemListCounter = 0;
            float customerOrderAmounts = 0.0f;
            for (int i = 0; i < customerOrderItemList.Length; i++)
            {
                customerOrderAmounts += customerOrderItemList[i].Amount;

            }
            var companyAmount = orderControlContext.Company.FirstOrDefault().CompanyAmount;
            var totalCompanyAmount = companyAmount - customerOrderAmounts;
            //var totalCompanyAmount = 400.0f;
            if (totalCompanyAmount > 0)
            {
            
                var updateCompany = orderControlContext.Company.FirstOrDefault(x => x.CompanyId == 1);
                updateCompany.CompanyAmount = totalCompanyAmount;
                orderControlContext.Company.Update(updateCompany);
                orderControlContext.SaveChanges();
            }
        }
        public Task StopAsync(CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }
}
