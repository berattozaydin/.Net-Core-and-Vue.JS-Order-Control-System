namespace OrderControlSystem.BLL.Models.FilterModels
{
    public class ReceiptWithFilterModel : BaseParameter
    {
        public int? ProcessStepsId { get; set; }
        public int? TreatmentTypeId { get; set; }
        public int? FurnanceId { get; set; }
        public string? Name { get; set; }
        public string? Remark { get; set; }
        public string? FurnaceName { get; set; }
        public string? TreatmentTypeName { get; set; }
        public override string SortField { get; set; } = "ProcessStepsId";
    }
}

