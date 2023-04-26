namespace OrderControlSystem.BLL.Models.FilterModels
{
    public class WorkOrderWithDetailFilterModel : BaseParameter
    {
        public int? WorkOrderId { get; set; }
        public int? WorkOrderStatusId { get; set; }
        public int? ReceiptId { get; set; }
        public string? WorkOrderNumber { get; set; }
        public string? Name { get; set; }
        public string? Remark { get; set; }

        // TODO: tarih filtrelemeleri değer aralıklı olmalı
        //
        //public DateTime? CreatedDate { get; set; }
        //public DateTime? StartedDate { get; set; }
        //public DateTime? EndDate { get; set; }
        //public DateTime? UpdatedDate { get; set; }
        public float? NgfNaturalGasStart { get; set; }
        public float? NgfNaturalGasEnd { get; set; }
        public float? EfHeaterRate1Avg { get; set; }
        public float? EfHeaterRate2Avg { get; set; }
        public float? IfGuc { get; set; }
        public float? IfVoltage { get; set; }
        public float? IfFreq { get; set; }
        public float? IfPower { get; set; }
        public float? IfCurrent { get; set; }
        public float? IfActualSpeed { get; set; }
        public float? IfReferenceSpeed { get; set; }
        public float? IfDuration { get; set; }
        public string? RemarkOperator { get; set; }
        public int? FurnaceId { get; set; }
        public int? activeIndexWorkOrder { get; set; }
        public override string? SortField { get; set; } = "WorkOrderId";


    }
}
