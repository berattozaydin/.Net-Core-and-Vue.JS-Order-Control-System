using System;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class Furnace1Datum
    {
        public int Furnace1DataId { get; set; }
        public int WorkOrderId { get; set; }
        public int FurnaceId { get; set; }
        public DateTime Dati { get; set; }
        public short? Tc1Temp { get; set; }
        public short? Tc2Temp { get; set; }
        public short? Tc3Temp { get; set; }
        public short? Tc4Temp { get; set; }
    }
}
