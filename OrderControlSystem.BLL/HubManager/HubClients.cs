using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrderControlSystem.BLL.HubManager
{
    public static class HubClients
    {
        public static List<HubClient> HubClientsList { get; set; } = new List<HubClient>();
    }
    public class HubClient
    {
        public string ConnectionId { get; set; }
        public string UserName { get; set; }
        public string Page { get; set; }
    }
}
