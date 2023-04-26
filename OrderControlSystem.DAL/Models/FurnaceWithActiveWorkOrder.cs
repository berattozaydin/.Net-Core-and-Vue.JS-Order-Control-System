using System;

namespace OrderControlSystem.DAL.Models
{
    public class FurnaceWithActiveWorkOrder
    {
        public int FurnanceId { get; set; }
        public int? WorkOrderId { get; set; }
        public DateTime? WorkOrderUpdateDate { get; set; }
    }
}
