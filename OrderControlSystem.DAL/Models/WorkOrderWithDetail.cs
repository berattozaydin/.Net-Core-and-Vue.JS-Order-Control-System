using System;

namespace OrderControlSystem.DAL.Models;

public class WorkOrderWithDetail
{
    public int WorkOrderId { get; set; }
    public int WorkOrderStatusId { get; set; }
    public int ReceiptId { get; set; }
    public string WorkOrderNumber { get; set; }
    public string Name { get; set; }
    public string Remark { get; set; }
    public DateTime CreatedDate { get; set; }
    public DateTime? StartedDate { get; set; }
    public DateTime? EndDate { get; set; }
    public DateTime? UpdatedDate { get; set; }
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
    public string RemarkOperator { get; set; }
    public string WorkOrderStatusName { get; set; }
    public string ReceiptName { get; set; }
    public int? FurnaceId { get; set; }
    public int TotalPieceNumber { get; set; }
    public int TotalPieceWeight { get; set; }
    public int TotalVolume { get; set; }


}
