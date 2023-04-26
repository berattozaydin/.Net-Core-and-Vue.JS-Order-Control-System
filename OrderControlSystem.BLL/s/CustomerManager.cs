using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System.Text;
using System.Linq;
using OrderControlSystem.DAL;
using OrderControlSystem.Core.Models;
using OrderControlSystem.Core;
using OrderControlSystem.BLL.Models;

namespace OrderControlSystem.BLL.Managers
{
	public class CustomerManager
	{
        private readonly OrderControlContext orderControlContext;
        private readonly string customerLink = "localhost:5035/sync/getCustomers.php";
        private readonly string syncLink = "localhost:5035/sync/completeCustomer.php";
        public CustomerManager(OrderControlContext orderControlContext)
		{
            this.orderControlContext = orderControlContext;
		}

        private async Task<bool> Add(Customer item)
        {
            await orderControlContext.Customers.AddAsync(item);
            if((await orderControlContext.SaveChangesAsync()) > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
           
        }

        public Response<List<Customer>> List()
        {
            Response<List<Customer>> response = new();
            var list = orderControlContext.Customers.ToList();
            response.Value = list;
            return response;
        }

        private async Task<bool> Update(Customer customer)
        {
            var updateCustomer = orderControlContext.Customers.FirstOrDefault(x=>x.CustomerId==customer.CustomerId);
            updateCustomer.CompanyCode = customer.CompanyCode;
            updateCustomer.CompanyFullName = customer.CompanyFullName;
            updateCustomer.CompanyName = customer.CompanyName;
            updateCustomer.CurrencyType = customer.CurrencyType;
            updateCustomer.TaxAdministration = customer.TaxAdministration;
            updateCustomer.TaxNumber = customer.TaxNumber;
            updateCustomer.Status = customer.Status;
            updateCustomer.Maturity = customer.Maturity;
            updateCustomer.Remark = (customer.Remark).SubstringSafe(200);
            updateCustomer.PartitionType = customer.PartitionType;
            orderControlContext.Customers.Update(updateCustomer);
            if((await orderControlContext.SaveChangesAsync()) > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
          
                
        }
        public async Task<ReturnResult> GetCustomerListWithAccounting()
        {
            var result = new ReturnResult();
            using var httpClient = new HttpClient();
            var response = await httpClient.GetFromJsonAsync<List<Customer>>(customerLink);
            if(response.Count==0)
            {
                return result = new ReturnResult { msg = "Liste Boş Senkronize Edilecek Veri Yok.", success = 1 };
            }
            foreach(var customer in response)
            {
                var checkCustomer = await CheckCustomer(customer);
                if(checkCustomer == false)
                {
                    var resultCustomer = await Add(customer);
                    if (resultCustomer == true)
                    {
                        var stringContent = await StringContent(customer);
                        var resultPostPHP = await httpClient.PostAsync(syncLink, stringContent);
                        result = await resultPostPHP.Content.ReadFromJsonAsync<ReturnResult>();
                    }
                    else
                    {
                        continue;
                    }
                }
                else
                {
                    var resultCustomer = await Update(customer);
                }
            }
            return result;
        }
        private async Task<StringContent> StringContent(Customer customer)
        {
            string serializeCustomer = System.Text.Json.JsonSerializer.Serialize(new
            {
                CustomerId = customer.CustomerId,
            });
            var stringContent = new StringContent(serializeCustomer, Encoding.UTF8, "application/json");
            return stringContent;
        }
        private async Task<bool> CheckCustomer(Customer customer)
        {
            var result = false;
            result = await orderControlContext.Customers.AnyAsync(x => x.CustomerId == customer.CustomerId);
            return result;
        }
    }
}

