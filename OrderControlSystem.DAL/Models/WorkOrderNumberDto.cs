using System.ComponentModel.DataAnnotations;

namespace OrderControlSystem.DAL.Models
{
    public class WorkOrderNumberDto
    {
        [Key]
        public string WorkOrderNumberCreated { get; set; }
    }
}
