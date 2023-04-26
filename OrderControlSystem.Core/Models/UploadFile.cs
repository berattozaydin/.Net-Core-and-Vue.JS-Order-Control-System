using Microsoft.AspNetCore.Http;

namespace OrderControlSystem.Core.Models
{
    public class UploadFile
    {
        public IFormFile Files { get; set; } = null;
        public string customerOrderItemId { get; set; }
    }
}

