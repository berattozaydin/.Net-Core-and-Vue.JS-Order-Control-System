using System.Collections.Generic;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class ProcessSteps
    {

        public int ProcessStepsId { get; set; }
        public int TreatmentTypeId { get; set; }
        public string Name { get; set; }
        public string Remark { get; set; }

        public virtual TreatmentType TreatmentType { get; set; }
    }
}
