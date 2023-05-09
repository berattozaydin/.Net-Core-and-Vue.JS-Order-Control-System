using OrderControlSystem.DAL.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class CustomerOrder
    {
        public CustomerOrder()
        {
            CustomerOrderItems = new HashSet<CustomerOrderItem>();
        }

        public string CustomerOrderId { get; set; }
        public int CustomerId { get; set; }
        public int CustomerOrderStatusId { get; set; }
        public string OrderNumber { get; set; }
        public string BarcodeNumber { get; set; }
        public string Name { get; set; }
        public string Remark { get; set; }
        public float TotalAmount { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; } = DateTime.Now;
        [NotMapped]
        public virtual CustomerOrderItemsDto CustomerOrderItemsDto { get; set; }
        public virtual Customer Customer { get; set; }
        public virtual CustomerOrderStatus CustomerOrderStatus { get; set; }
        public virtual ICollection<CustomerOrderItem> CustomerOrderItems { get; set; }
    }
}
