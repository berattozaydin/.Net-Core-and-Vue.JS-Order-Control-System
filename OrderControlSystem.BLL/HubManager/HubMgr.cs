using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrderControlSystem.BLL.HubManager
{
    public class HubMgr:Hub
    {
        public override async Task OnConnectedAsync()
        {
            HubClients.HubClientsList
                .Add(
                new HubClient
                {
                    ConnectionId = Context.ConnectionId,
                    UserName=Context.User?.Identity.Name,
                    Page = Context.GetHttpContext()?.Request.Query["pagename"]
                });
           await base.OnConnectedAsync();
        }
        public override Task OnDisconnectedAsync(Exception? exception)
        {
            var wsClientConnection = WsClients.WsClientsList.FirstOrDefault(x => x.ConnectionId==Context.ConnectionId);
            if (wsClientConnection.Page == "/trk")
                WsClients.WsClientsList.Remove(wsClientConnection);

            return base.OnDisconnectedAsync(exception);
        }
    }
}
