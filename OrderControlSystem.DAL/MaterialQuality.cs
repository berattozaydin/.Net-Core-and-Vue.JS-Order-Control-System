using System;
using System.Collections.Generic;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class MaterialQuality
    {
        public MaterialQuality()
        {
            CustomerOrderItems = new HashSet<CustomerOrderItem>();
        }

        public int MaterialQualityId { get; set; }
        public string Code { get; set; }
        public string Name { get; set; }
        public string Remark { get; set; }
        public DateTime CreatedDatetime { get; set; }
        public DateTime? UpdatedDatetime { get; set; }

        public virtual ICollection<CustomerOrderItem> CustomerOrderItems { get; set; }
    }
}
