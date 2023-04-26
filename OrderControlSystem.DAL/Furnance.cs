using System.Collections.Generic;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class Furnance
    {
        public Furnance()
        {
            Receipts = new HashSet<Receipt>();
        }

        public int FurnanceId { get; set; }
        public string Name { get; set; }

        public virtual ICollection<Receipt> Receipts { get; set; }
    }
}
