using System;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class Account
    {
        public int Id { get; set; }
        public int? CustomerId { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public short Role { get; set; }
        public string Name { get; set; }
        public string LastName { get; set; }
        public DateTime CreateDati { get; set; }
        public DateTime? UpdateDati { get; set; }
        public bool? IsActive { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }

        public virtual Customer Customer { get; set; }
        public virtual Role RoleNavigation { get; set; }
    }
}
