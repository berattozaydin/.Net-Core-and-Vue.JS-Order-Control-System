using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace OrderControlSystem.DAL.Models
{
    public class CustomerOrderItemsDto
    {
        public string CustomerOrderItemId { get; set; }
        public string CustomerOrderId { get; set; }
        public int CustomerOrderItemStatusId { get; set; }
        public int CustomerId { get; set; }
        public int TreatmentTypeId { get; set; }
        public int? MaterialQualityId { get; set; }
        public string MaterialQualityUnknown { get; set; }
        public string Name { get; set; }
        public string DrawingNo { get; set; }
        public int PieceNumber { get; set; }
        public int PieceWeight { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public int Depth { get; set; }
        public int Hrc { get; set; }
        public int Hb { get; set; }

        public string ReceiptName { get; set; }

        public DateTime RegistrationDate { get; set; }
        public DateTime CreateDate { get; set; }
        [NotMapped]
        public virtual string? MaterialQualityName { get; set; }
        [NotMapped]
        public virtual string? TreatmentTypeName { get; set; }
        [NotMapped]
        public virtual string? CustomerOrderItemStatusName { get; set; }
        [NotMapped]
        public virtual string? CustomerCompanyName { get; set; }
        public virtual Customer Customer { get; set; }
        public virtual CustomerOrder CustomerOrder { get; set; }
        public virtual CustomerOrderItemStatus CustomerOrderItemStatus { get; set; }
        public virtual MaterialQuality MaterialQuality { get; set; }
        public virtual TreatmentType TreatmentType { get; set; }
    }
}
