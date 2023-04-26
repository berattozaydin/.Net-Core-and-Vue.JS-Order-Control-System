using System.Collections.Generic;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class CustomerOrderStatus
    {
        public CustomerOrderStatus()
        {
            CustomerOrders = new HashSet<CustomerOrder>();
        }

        public int CustomerOrderStatusId { get; set; }
        public string Name { get; set; }

        public virtual ICollection<CustomerOrder> CustomerOrders { get; set; }
    }
}
