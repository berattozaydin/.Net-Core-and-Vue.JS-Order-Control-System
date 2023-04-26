using OrderControlSystem.Core.Types;
using System;

namespace OrderControlSystem.Core.Models
{
    public class Level2ToLevel3
    {
        public int workOrderId { get; set; }
        public WorkOrderStatusId workOrderStatusId { get; set; }
        public int workOrderItemId { get; set; }
        public int customerOrderStatusId { get; set; }
        public DateTime? EndDate { get; set; }
    }
    public class L2ToL3WorkOrderData
    {
        public int WorkOrderId { get; set; }
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
    }
}

