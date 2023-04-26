namespace OrderControlSystem.DAL.Models
{
    public class AccountDto
    {
        public int? Id { get; set; }
        public int? CustomerId { get; set; }
        public string? Username { get; set; }
        public string? Password { get; set; }
        public short Role { get; set; }
        public string? Name { get; set; }
        public string? LastName { get; set; }
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
        public bool? IsActive { get; set; }
    }
}
