#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class ReceiptDetail
    {
        public int ReceiptDetailId { get; set; }
        public int ReceiptId { get; set; }
        public int HeatingTime { get; set; }
        public int Temperature { get; set; }
        public int StepNo { get; set; }

        public virtual ProcessSteps Receipt { get; set; }
    }
}
