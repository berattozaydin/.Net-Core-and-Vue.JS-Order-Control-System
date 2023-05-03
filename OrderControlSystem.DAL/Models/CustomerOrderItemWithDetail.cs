using System;

namespace OrderControlSystem.DAL.Models
{
    public class CustomerOrderItemWithDetail
    {
        public string? CustomerOrderItemId { get; set; }
        public string? CustomerOrderId { get; set; }
        public int? CustomerOrderItemStatusId { get; set; }
        public int? CustomerId { get; set; }
        public int? TreatmentTypeId { get; set; }
        public string? Name { get; set; }
        public string? DrawingNo { get; set; }
        public int? PieceNumber { get; set; }
        public int? PieceWeight { get; set; }
        public int? Width { get; set; }
        public int? Height { get; set; }
        public int? Depth { get; set; }
        public int? Hrc { get; set; }
        public int? Hb { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? RegistrationDate { get; set; }
        public DateTime? RequestDate { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? FinishDate { get; set; }
        public DateTime? ShippingDate { get; set; }
        public string? Remark { get; set; }
        public string? FilePath { get; set; }

        public int? NextHrc { get; set; }
        public int? NextHb { get; set; }
        public string? CustomerName { get; set; }
        public string? CustomerOrderItemStatusName { get; set; }
        public string? TreatmentTypeName { get; set; }
        public string? CustomerOrderName { get; set; }
    }
}

