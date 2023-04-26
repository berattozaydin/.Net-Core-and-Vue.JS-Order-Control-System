using System;

namespace OrderControlSystem.DAL.Models
{
    public class CustomerOrderDto
    {
        public string CustomerOrderId { get; set; }
        public int CustomerId { get; set; }
        public int CustomerOrderStatusId { get; set; }
        public string OrderNumber { get; set; }
        public string Name { get; set; }
        public string Remark { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; } = DateTime.Now;
        public CustomerOrderItemsDto CustomerOrderItem { get; set; }
    }
}
