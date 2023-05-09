using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.WebSockets;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using MySqlX.XDevAPI.Common;
using OrderControlSystem.BLL.HandleMiddleware;
using OrderControlSystem.Core.Types;
using OrderControlSystem.DAL;
using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net.WebSockets;
using System.Reflection.PortableExecutable;
using System.Text;
using System.Threading.Tasks;

namespace OrderControlSystemService.Src
{
    public class CompanyAmountService
    {
        
        CancellationToken cancellationToken;
        SerialPort serialPort = new SerialPort {BaudRate=9600,PortName="COM1" };
        public CompanyAmountService(CancellationToken cancellationToken)
        {
            this.cancellationToken = cancellationToken;
            
        }
        public async Task StartAsnyc(CancellationToken cancellationToken)
        {
            while(!cancellationToken.IsCancellationRequested)
            {
                
                try
                {
                    //ShoppingCart_CallBack();
                    BarcodeSystem_CallBack();
                    /*if (serialPort.IsOpen)
                    {
                        WriteSerialPort();
                    }
                    else
                    {
                        serialPort.Open();
                    }*/

                }
                catch(Exception ex)
                {
                    Console.WriteLine(ex);
                }
                await Task.Delay(2000);
            }
        }
        public void WriteSerialPort()
        {
            try
            {
                serialPort.Write("1");
                serialPort.Close();
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex);
            }

        }
        public async void BarcodeSystem_CallBack()
        {
            var barcodeSystem = new List<CustomerOrder>();
            var barcodeSystemDataStorage = new Dictionary<string, string>();
            string[] colorArray = new string[] { "YELLOW","RED", "GREEN" };

            for (int i = 0;i<barcodeSystem.Count;i++)
            {
                if (!(barcodeSystem.Count > 0))
                    break;
                barcodeSystemDataStorage.Add(colorArray[0],barcodeSystem[i].BarcodeNumber); 

            }
            for(int i = 0;i< barcodeSystemDataStorage.Count; i++)
            {
                if (!(barcodeSystemDataStorage.Count > 0))
                    break;
               var res =  barcodeSystemDataStorage[colorArray[0]];
                var orderControlContext = new OrderControlContext();
                var updateCustomerOrder = orderControlContext.CustomerOrders.FirstOrDefault(x => x.BarcodeNumber == res);
                updateCustomerOrder.ColorName = res;
                orderControlContext.CustomerOrders.Update(updateCustomerOrder);
                orderControlContext.SaveChanges();
            }

        }
        public async void ShoppingCart_CallBack()
        {
            OrderControlContext orderControlContext = new OrderControlContext();
            var customerOrderItemList = await orderControlContext.CustomerOrderItems.Where(x => x.CustomerOrderItemStatusId == (int)CustomerOrderItemStatusId.PaketlemeAsamasinda).ToArrayAsync();
            int itemListCounter = 0;
            float customerOrderAmounts = 0.0f;
            for (int i = 0; i < customerOrderItemList.Length; i++)
            {
                customerOrderAmounts += customerOrderItemList[i].Amount;

            }
            
           var updateCompany = orderControlContext.Company.FirstOrDefault(x => x.CompanyId == 1);
            
             var totalCompanyAmount = updateCompany.CompanyAmount;
            if (totalCompanyAmount > 0)
            {
                updateCompany.CompanyAmount = totalCompanyAmount;
                orderControlContext.Company.Update(updateCompany);
                orderControlContext.SaveChanges();
            }
            //await CheckBarcodeAsync();
        }
        public async Task CheckBarcodeAsync()
        {
            string data = "";
            OrderControlContext orderControlContext = new OrderControlContext();
            while (serialPort.IsOpen)
            {
                if (!serialPort.IsOpen)
                {
                    break;
                }
                data = serialPort.ReadLine();
                WriteConsole(data);
                if (string.IsNullOrEmpty(data))
                {
                    continue;
                }
                var res = await CheckBarcodeData(data);
                if(res == false)
                {
                    var args = new Log
                    {
                        CreatedDate = DateTime.Now,
                        LogStatusCode = 404,
                        LogDescription = "Program Hata. Barkod Onaylanmadı Servis Durdu.",
                        LogMethod = "Service/CheckBarcodeData",
                        MachineName = Environment.MachineName,
                        LogPath = "CompanyAmountService"
                    };
                    orderControlContext.Logs.Add(args);
                    orderControlContext.SaveChanges();
                    break;
                }
                await Task.Delay(4000);
            }

        }
        private async Task<bool> CheckBarcodeData(string data)
        {
            var result = false;
            OrderControlContext orderControlContext = new OrderControlContext();
           
            try
            {
                var res = orderControlContext.CustomerOrders.Any(x => x.BarcodeNumber == data);

                if (res == false) 
                {
                    //Add New CustomerOrder Block;
                    
                }
                else
                {
                    //Update Exist CustomerOrder Block;
                }

            }catch(Exception ex)
            {
                var args = new Log
                {
                    CreatedDate = DateTime.Now,
                    LogStatusCode = 404,
                    LogDescription = ("Program Hata. "+ex.Message),
                    LogMethod = "Service/CheckBarcodeData",
                    MachineName = Environment.MachineName,
                    LogPath = "CompanyAmountService"
                };
                orderControlContext.Logs.Add(args);
                orderControlContext.SaveChanges();
            }
            return result;
        }
        private void WriteConsole(string data)
        {
            Console.WriteLine("Data Geldi : " + data + " " + DateTime.Now + "  " + " Geliş Zamanı");
        }
        public Task StopAsync(CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }
}
