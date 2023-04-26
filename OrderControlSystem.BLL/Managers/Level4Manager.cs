using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Net.Http;
using System.Text.Json;
using Newtonsoft.Json;
using System.Net.Http.Json;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Text.Json.Serialization;
using DocumentFormat.OpenXml.Drawing.Charts;
using DocumentFormat.OpenXml.Wordprocessing;
using DocumentFormat.OpenXml.Bibliography;
using OrderControlSystem.DAL;
using OrderControlSystem.Core.Models;
using OrderControlSystem.BLL.Models;

namespace OrderControlSystem.Managers
{
    public class Level4Manager
    {
        private readonly OrderControlContext orderControlContext;
        
        private readonly CustomerOrderManager customerOrderManager;
        private readonly CustomerOrderItemManager customerOrderItemManager;
        private readonly Mapper mapperCo = new Mapper(Level4ConfigCustomerOrder());
        private readonly Mapper mapperCoi = new Mapper(Level4ConfigCustomerOrderItem());
        
        public Level4Manager(CustomerOrderManager customerOrderManager,CustomerOrderItemManager customerOrderItemManager,OrderControlContext orderControlContext)
        {
            this.orderControlContext = orderControlContext;
            this.customerOrderItemManager = customerOrderItemManager;
            this.customerOrderManager = customerOrderManager;
        }
        public async Task<List<CustomerOrderItem>> GetCustomerOrderItem(string customerOrder)
        {
            var localhostUri = "http:// localhost:5035/bend/api/OrderDetail.php?getl3";
            var publishUri = "https:// localhost:5035 /app/api/OrderDetail.php?getl3";
            using var httpClient = new HttpClient();
            var customerOrderId = System.Text.Json.JsonSerializer.Serialize(new { CustomerOrderId = customerOrder });
            var request = new HttpRequestMessage
            {
                Method = HttpMethod.Get,
                RequestUri = new Uri(publishUri),
                Content = new StringContent(customerOrderId, Encoding.UTF8, "application/json")
            };
            List<CustomerOrderItem> customerOrderItems = new();
            var result = await httpClient.SendAsync(request);
            var body = await result.Content.ReadAsStringAsync().ConfigureAwait(false);
            var jsonList = JsonConvert.DeserializeObject<Level4Response<List<CustomerOrderItemService>>>(body);
            foreach(var co in jsonList.value)
            {
                var map = new CustomerOrderItem{
                    CustomerId = co.CustomerId,
                    CreateDate = DateTime.Parse(co.CreateDate),
                    CustomerOrderId = co.CustomerOrderId,
                    CustomerOrderItemId = co.CustomerOrderItemId,
                    CustomerOrderItemStatusId = co.CustomerOrderItemStatusId,
                    Name = co.Name,
                    DrawingNo = co.DrawingNo,
                    Depth = co.Depth,
                    FinishDate = DateTime.Parse(co.FinishDate),
                    Hb = co.Hb,
                    Hrc = co.Hrc,
                    Height = co.Height,
                    MaterialQualityId = co.MaterialQualityId,
                    PieceNumber = co.PieceNumber,
                    PieceWeight = co.PieceWeight,
                    TreatmentTypeId = co.TreatmentTypeId,
                    Width = co.Width,
                    ShippingDate = DateTime.Parse(co.ShippingDate),
                    RegistrationDate = DateTime.Parse(co.RegistrationDate),
                    Remark = co.Remark,
                    RequestDate = DateTime.Parse(co.RequestDate),
                    StartDate = DateTime.Parse(co.StartDate),
                };
                customerOrderItems.Add(map);
            }
            return customerOrderItems;

        }
        public async Task<List<CustomerOrder>> GetCustomerOrder()
        {
            var localhostUri = "http:// localhost:5035/bend/api/Order.php?get";
            var publishUri = new Uri("https:// localhost:5035 /app/api/Order.php?get");

            using var httpClient = new HttpClient();
            var response = await httpClient.GetFromJsonAsync<Level4Response<List<CustomerOrder>?>>(publishUri);
            return response.value;
           
        }
        public async Task<ReturnResult> UpdateL4Status(Level3Tolevel4<CustomerOrder> level3Tolevel4)
        {
            //var localhostUri = "http:// localhost:5035/bend/api/Order.php?update";
            var publishUri = new Uri("https:// localhost:5035 /app/api/Order.php?update");
            using var httpClient = new HttpClient();
            var response = new ReturnResult { };
            var res = new ReturnResult { };
            foreach (var item in level3Tolevel4.customerOrder)
            {
                var serializeCustomerOrder = System.Text.Json.JsonSerializer.Serialize(new
                {
                    CustomerOrderId = item.CustomerOrderId,
                    CustomerId = item.CustomerId,
                    CustomerOrderStatusId = level3Tolevel4.statusId,
                    OrderNumber = item.OrderNumber,
                    Name = item.Name,
                    Remark = item.Remark
                });
             
                var stringContent = new StringContent(serializeCustomerOrder.ToString(), Encoding.UTF8, "application/json");
                var result = httpClient.PostAsync(publishUri,stringContent).Result;
                var cont = result.Content.ReadAsStringAsync().Result;
                var check = await orderControlContext.CustomerOrders.AnyAsync(x => x.CustomerOrderId == item.CustomerOrderId);
                if(check ==false)
                    res = await customerOrderManager.AddCustomerOrder(item);
                else
                {
                    res = await customerOrderManager.UpdateCustomerOrder(item);
                }
                if (res.success == 1)
                {
                    response = new ReturnResult
                    {
                        id = item.CustomerOrderId,
                        success = 1,
                        Value = "Başarılı.."
                    }; ;
                    var resItem = await CustomerOrderItemAdd(item.CustomerOrderId);
                    if(resItem == false)
                    {
                        response = new ReturnResult
                        {
                            id= item.CustomerOrderId,
                            success = 0,
                            Value = "Malzeme Kalitesi Bilinmiyor"
                        };
                       return response;
                    }
                }
            }
            return response;
        }
        private async Task<bool> CustomerOrderItemAdd(string customerOrder)
        {
            var localhostUri = "http:// localhost:5035/bend/api/OrderDetail.php?getl3";
            var publishUri = "http:// localhost:5035 /app/api/OrderDetail.php?getl3";
            var response = false;
            var coi = new CustomerOrderItem { };
            using var httpClient = new HttpClient();
            var customerOrderId = System.Text.Json.JsonSerializer.Serialize(new { CustomerOrderId=customerOrder});
            var request = new HttpRequestMessage
            {
                Method = HttpMethod.Get,
                RequestUri = new Uri(publishUri),
                Content = new StringContent(customerOrderId, Encoding.UTF8, "application/json")
            };
             
            var result = await httpClient.SendAsync(request);
            var body = await result.Content.ReadAsStringAsync().ConfigureAwait(false);
            var jsonList = JsonConvert.DeserializeObject<Level4Response<List<CustomerOrderItemService>>>(body);
            foreach(var co in jsonList.value)
            {
                if(co.MaterialQualityId != null)
                {
                    coi = new CustomerOrderItem
                    {
                        CustomerId = co.CustomerId,
                        CreateDate = DateTime.Parse(co.CreateDate),
                        CustomerOrderId = co.CustomerOrderId,
                        CustomerOrderItemId = co.CustomerOrderItemId,
                        CustomerOrderItemStatusId = co.CustomerOrderItemStatusId,
                        Name = co.Name,
                        DrawingNo = co.DrawingNo,
                        Depth = co.Depth,
                        FinishDate = DateTime.Parse(co.FinishDate),
                        Hb = co.Hb,
                        Hrc = co.Hrc,
                        Height = co.Height,
                        MaterialQualityId = co.MaterialQualityId,
                        PieceNumber = co.PieceNumber,
                        PieceWeight = co.PieceWeight,
                        TreatmentTypeId = co.TreatmentTypeId,
                        Width = co.Width,
                        ShippingDate = DateTime.Parse(co.ShippingDate),
                        RegistrationDate = DateTime.Parse(co.RegistrationDate),
                        Remark = co.Remark,
                        RequestDate = DateTime.Parse(co.RequestDate),
                        StartDate = DateTime.Parse(co.StartDate),
                    };
                    response = true;
                    var item = await orderControlContext.CustomerOrderItems.AnyAsync(x => x.CustomerOrderItemId == co.CustomerOrderItemId);
                    if(item == true)
                    {
                        customerOrderItemManager.Update(coi);
                    }
                    else
                    {
                        customerOrderItemManager.Add(coi);
                    }
                    
                }
                else
                {
                        response=false;
                }
            }
            return response;
        }
        private static MapperConfiguration Level4ConfigCustomerOrder()
        {
            var configL3 = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<Level4Response<List<CustomerOrder>?>,CustomerOrder>();
                
            });
            return configL3;
        }


        /*-------------------*/



        private async Task<bool> PostDataCustomerOrder(string url, CustomerOrder customerOrder)
        {

            using var httpClient = new HttpClient();
            string serializeCustomerOrder = System.Text.Json.JsonSerializer.Serialize(new
            {
                CustomerOrderId = customerOrder.CustomerOrderId,
                CustomerOrderStatusId = customerOrder.CustomerOrderStatusId,
                CustomerId = customerOrder.CustomerId,
                OrderNumber = customerOrder.OrderNumber,
                Name = customerOrder.Name,
                Remark = customerOrder.Remark
            });
            var stringContent = new StringContent(serializeCustomerOrder, Encoding.UTF8, "application/json");
            var result = httpClient.PostAsync("http:// localhost:5035/bend/" + url, stringContent).Result;
            var res = result.Content;
            if (result.IsSuccessStatusCode)
            {
                return true;
            }
            else
            {
                return false;
            }

        }
        private async Task<bool> PostDataCustomerOrderItem(string url, CustomerOrderItem customerOrderItem)
        {
            var publishUrl = new Uri("http:// localhost:5035/bend/" + url);
            using var httpClient = new HttpClient();
            string serializeCustomerOrderItem = System.Text.Json.JsonSerializer.Serialize(new
            {
                CustomerOrderItemId = customerOrderItem.CustomerOrderItemId,
                CustomerOrderId = customerOrderItem.CustomerOrderId,
                CustomerOrderItemStatusId = customerOrderItem.CustomerOrderItemStatusId,
                CustomerId = customerOrderItem.CustomerId,
                TreatmentTypeId = customerOrderItem.TreatmentTypeId,
                MaterialQualityId = customerOrderItem.MaterialQualityId,
                Name = customerOrderItem.Name,
                DrawingNo = customerOrderItem.DrawingNo,
                PieceNumber = customerOrderItem.PieceNumber,
                PieceWeight = customerOrderItem.PieceWeight,
                Width = customerOrderItem.Width,
                Height = customerOrderItem.Height,
                Depth = customerOrderItem.Depth,
                Hrc = customerOrderItem.Hrc,
                Hb = customerOrderItem.Hb,
                CreateDate = customerOrderItem.CreateDate,
                RegistrationDate = customerOrderItem.RegistrationDate,
                RequestDate = customerOrderItem.RequestDate,
                StartDate = customerOrderItem.StartDate,
                FinishDate = customerOrderItem.FinishDate,
                ShippingDate = customerOrderItem.ShippingDate,
                Remark = customerOrderItem.Remark
            });
            var stringContent = new StringContent(serializeCustomerOrderItem, UnicodeEncoding.UTF8, "application/json");
            var result = httpClient.PostAsync(publishUrl, stringContent).Result;
            if (result.IsSuccessStatusCode)
            {
                return true;
            }
            else
            {
                return false;
            }

        }
        public async Task<bool> SetDataToLevel4CustomerOrder()
        {
            using var httpClient = new HttpClient();
            var result = false;
            string addUrl = "api/order.php?add";
            string updateUrl = "api/order.php?update";
            var customerOrder = await orderControlContext.CustomerOrders.ToListAsync();
            var response = await httpClient.GetFromJsonAsync<Level4Response<List<CustomerOrder>?>>("http:// localhost:5035/bend/api/order.php?get");
            foreach (var item in response.value)
            {
                foreach (var customerOrderId in customerOrder)
                {
                    if (customerOrderId.CustomerOrderId == item.CustomerOrderId)
                    {
                        result = await PostDataCustomerOrder(updateUrl, customerOrderId);
                    }
                    else
                    {
                        result = await PostDataCustomerOrder(addUrl, customerOrderId);
                    }
                }
            }
            if (result == true)
            {
                var customerOrderItemResult = await SetDataToLevel4CustomerOrderItem();
                if (customerOrderItemResult == true)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        private async Task<bool> SetDataToLevel4CustomerOrderItem()
        {
            var result = false;
            string addPost = "api/orderDetail.php?add";
            string updatePost = "api/orderDetail.php?update";
            using var httpClient = new HttpClient();
            var customerOrderItemList = await orderControlContext.CustomerOrderItems.ToListAsync();
            var response = await httpClient.GetFromJsonAsync<Level4Response<List<CustomerOrderItemService>?>>("http:// localhost:5035/bend/api/orderDetail.php?getl3");
            foreach (var item in response.value)
            {
                foreach (var list in customerOrderItemList)
                {
                    if (list.CustomerOrderItemId == item.CustomerOrderItemId)
                    {
                        result = await PostDataCustomerOrderItem(updatePost, list);
                    }
                    else
                    {
                        result = await PostDataCustomerOrderItem(addPost, list);
                    }
                }
            }
            if (result == true)
            {
                return result;
            }
            else
            {
                return result;
            }

        }




        /*-------------------*/

        private static MapperConfiguration Level4ConfigCustomerOrderItem()
        {
            var configL3 = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<List<CustomerOrderItemService>,CustomerOrderItem>();

            });
            return configL3;
        }
       
    }
}

