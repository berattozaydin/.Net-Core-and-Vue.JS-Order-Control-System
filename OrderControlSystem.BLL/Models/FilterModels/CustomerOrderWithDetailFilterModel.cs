namespace OrderControlSystem.BLL.Models.FilterModels
{
    public class CustomerOrderWithDetailFilterModel : BaseParameter
    {
        public string? CustomerOrderId { get; set; }
        public int? CustomerId { get; set; }
        public int? CustomerOrderStatusId { get; set; }
        public string? OrderNumber { get; set; }
        public string? CustomerName { get; set; }
        public string? Name { get; set; }
        public string? Remark { get; set; }
        public int? ActiveIndexCustomerOrder { get; set; }
        public override string SortField { get; set; } = "CustomerOrderId";
    }
}

