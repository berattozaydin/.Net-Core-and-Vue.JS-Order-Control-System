namespace OrderControlSystem.Core.Models
{
    public class Response<T>
    {
        public T Value { get; set; }
        public string? msg { get; set; }
        public bool IsSuccess { get; set; } = true;
        public int? TotalRecords { get; set; }
    }
}
