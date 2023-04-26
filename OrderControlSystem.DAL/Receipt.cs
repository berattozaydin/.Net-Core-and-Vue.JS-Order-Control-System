using System.Collections.Generic;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class Receipt
    {
        public Receipt()
        {
            ReceiptDetails = new HashSet<ReceiptDetail>();
        }

        public int ReceiptId { get; set; }
        public int TreatmentTypeId { get; set; }
        public int FurnanceId { get; set; }
        public string Name { get; set; }
        public string Remark { get; set; }

        public virtual Furnance Furnance { get; set; }
        public virtual TreatmentType TreatmentType { get; set; }
        public virtual ICollection<ReceiptDetail> ReceiptDetails { get; set; }
    }
}
