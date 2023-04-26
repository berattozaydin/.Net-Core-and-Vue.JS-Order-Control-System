using System.Collections.Generic;

namespace OrderControlSystem.BLL.Models
{
    public class CustomerReport
    {
        public string FormDate { get; set; }
        public string CompanyName { get; set; }
        public string StartDate { get; set; }
        public string DrawingNo { get; set; }
        public string Name { get; set; }
        public int PieceNumber { get; set; }
        public int PieceWeight { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public int Depth { get; set; }
        public string ShippingDate { get; set; }
        public List<FurnaceGeneralData> FurnaceDataList { get; set; }
        public string TreatmentTypeName { get; internal set; }
    }
}
