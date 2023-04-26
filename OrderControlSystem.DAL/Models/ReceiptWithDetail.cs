namespace OrderControlSystem.DAL.Models
{
    public class ReceiptWithDetail
    {
        public int? ReceiptId { get; set; }
        public int? TreatmentTypeId { get; set; }
        public int? FurnanceId { get; set; }
        public string? Name { get; set; }
        public string? Remark { get; set; }
        public string? FurnaceName { get; set; }
        public string? TreatmentTypeName { get; set; }
    }
}

