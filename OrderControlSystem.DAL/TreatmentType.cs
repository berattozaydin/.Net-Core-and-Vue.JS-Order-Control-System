using System.Collections.Generic;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class TreatmentType
    {
        public TreatmentType()
        {
            CustomerOrderItems = new HashSet<CustomerOrderItem>();
            Receipts = new HashSet<ProcessSteps>();
        }

        public int TreatmentTypeId { get; set; }
        public string Name { get; set; }

        public virtual ICollection<CustomerOrderItem> CustomerOrderItems { get; set; }
        public virtual ICollection<ProcessSteps> Receipts { get; set; }
    }
}
