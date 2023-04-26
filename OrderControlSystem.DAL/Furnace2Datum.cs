using System;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class Furnace2Datum
    {
        public int Furnace2DataId { get; set; }
        public int WorkOrderId { get; set; }
        public int FurnaceId { get; set; }
        public DateTime Dati { get; set; }
        public short TopSideTemp { get; set; }
        public short BottomSideTemp { get; set; }
        public short CoverTemp { get; set; }
        public short Heater1Rate { get; set; }
        public short Heater2Rate { get; set; }
    }
}
