using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using System;
using System.Linq;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace OrderControlSystem.BLL.HandleMiddleware
{
    public class WebsocketManager
    {

        public WebsocketManager()
        {


        }

        public async static Task SendAsync(WebSocket webSocket, string ms = null)
        {
            var buffer = new byte[1024 * 4];
            /*var list = tpHetrL2Context.Furnace1Data.OrderByDescending(x => x.Furnace1DataId).Select(x => new
            {
                x.Tc1Temp,
                x.Tc2Temp,
                x.Tc3Temp,
                x.Tc4Temp
            }).FirstOrDefault();
            var electricalFurnace = tpHetrL2Context.Furnace2Data.OrderByDescending(x => x.Furnace2DataId).Select(x => new
            {
                x.Heater1Rate,
                x.Heater2Rate

            }).FirstOrDefault();
            var res = new
            {
                List = list,
                ElectricalFurnace = electricalFurnace
            };
            var convertJson = JsonConvert.SerializeObject(res);*/
            try
            {
                //await webSocket.SendAsync(new ArraySegment<byte>(Encoding.UTF8.GetBytes(convertJson.ToString())), WebSocketMessageType.Text, true, CancellationToken.None);

            }
            catch (Exception ex)
            {
                Console.WriteLine("ex : " + ex);
            }

        }
    }
}
