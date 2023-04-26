using System;

namespace OrderControlSystem.DAL.Models
{
    public class CustomerOrderWithDetail
    {
        public string? CustomerOrderId { get; set; }
        public int? CustomerId { get; set; }
        public int? CustomerOrderStatusId { get; set; }
        public string? OrderNumber { get; set; }
        public string? Name { get; set; }
        public string? Remark { get; set; }
        public string? CustomerOrderStatusName { get; set; }
        public string? CustomerName { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
}

