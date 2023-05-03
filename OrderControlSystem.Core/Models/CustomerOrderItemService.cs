namespace OrderControlSystem.Core.Models
{
    public class CustomerOrderItemService
    {
        public string CustomerOrderItemId { get; set; }
        public string CustomerOrderId { get; set; }
        public int CustomerOrderItemStatusId { get; set; }
        public int CustomerId { get; set; }
        public string Name { get; set; }
        public string DrawingNo { get; set; }
        public int TreatmentTypeId { get; set; }
        public int PieceNumber { get; set; }
        public int PieceWeight { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public int Depth { get; set; }
        public int Hrc { get; set; }
        public int Hb { get; set; }
        public string CreateDate { get; set; }
        public string RegistrationDate { get; set; }
        public string RequestDate { get; set; }
        public string StartDate { get; set; }
        public string FinishDate { get; set; }
        public string ShippingDate { get; set; }
        public string Remark { get; set; }
    }
}

