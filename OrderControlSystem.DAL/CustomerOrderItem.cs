using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class CustomerOrderItem
    {

        public string CustomerOrderItemId { get; set; } = Guid.NewGuid().ToString();
        public string CustomerOrderId { get; set; }
        public int CustomerOrderItemStatusId { get; set; }
        public int CustomerId { get; set; }
        public int TreatmentTypeId { get; set; }
        public string Name { get; set; }
        public int PieceNumber { get; set; }
        public int PieceWeight { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime? RegistrationDate { get; set; }
        public DateTime? RequestDate { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? FinishDate { get; set; }
        public DateTime? ShippingDate { get; set; }
        public string Remark { get; set; }
        public string FilePath { get; set; }
        public float Amount { get; set; }
        [NotMapped]
        public virtual string TreatmentTypeName { get; set; }
        [NotMapped]
        public virtual string CustomerOrderItemStatusName { get; set; }
        [NotMapped]
        public virtual string CustomerCompanyName { get; set; }
        public virtual Customer Customer { get; set; }
        public virtual CustomerOrder CustomerOrder { get; set; }
        public virtual CustomerOrderItemStatus CustomerOrderItemStatus { get; set; }
        public virtual TreatmentType TreatmentType { get; set; }
    }
}
