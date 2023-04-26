namespace OrderControlSystem.Core.Models
{
    public class Result
    {
        public object? Value { get; set; }
        public bool IsSuccess { get; set; }
        public string? msg { get; set; }
    }
}

