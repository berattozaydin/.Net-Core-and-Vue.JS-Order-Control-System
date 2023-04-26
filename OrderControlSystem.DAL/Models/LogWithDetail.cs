using System;

namespace OrderControlSystem.DAL.Models
{
    public class LogWithDetail
    {
        public int? Id { get; set; }
        public string? LogDescription { get; set; }
        public string? LogMethod { get; set; }
        public int? LogStatusCode { get; set; }
        public string? LogPath { get; set; }
        public string? MachineName { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;
    }
}

