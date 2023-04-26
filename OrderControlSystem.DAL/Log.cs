using System;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class Log
    {
        public int Id { get; set; }
        public string LogDescription { get; set; }
        public string LogMethod { get; set; }
        public int? LogStatusCode { get; set; }
        public string LogPath { get; set; }
        public string MachineName { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
