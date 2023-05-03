using System.Collections.Generic;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class Furnance
    {
        public Furnance()
        {
            Receipts = new HashSet<ProcessSteps>();
        }

        public int FurnanceId { get; set; }
        public string Name { get; set; }

        public virtual ICollection<ProcessSteps> Receipts { get; set; }
    }
}
