using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using OrderControlSystem.Core.Types;
using OrderControlSystem.DAL;
using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
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
                    ShoppingCart_CallBack();
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
        /*public void WriteSerialPort()
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

        }*/
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
            //updateCompany.CompanyAmount += 5.0f;
            
             var totalCompanyAmount = updateCompany.CompanyAmount;
            if (totalCompanyAmount > 0)
            {
                updateCompany.CompanyAmount = totalCompanyAmount;
                orderControlContext.Company.Update(updateCompany);
                orderControlContext.SaveChanges();
            }
            CheckBarcodeAsync();
        }
        public async Task CheckBarcodeAsync()
        {
            string data = "";
            OrderControlContext orderControlContext = new OrderControlContext();
            while (!serialPort.IsOpen)
            {
               data= serialPort.ReadLine();
                WriteConsole(data);
                await Task.Delay(4000);
            }

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
