using System.Collections.Generic;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class CustomerOrderItemStatus
    {
        public CustomerOrderItemStatus()
        {
            CustomerOrderItems = new HashSet<CustomerOrderItem>();
        }

        public int CustomerOrderItemStatusId { get; set; }
        public string Name { get; set; }

        public virtual ICollection<CustomerOrderItem> CustomerOrderItems { get; set; }
    }
}
