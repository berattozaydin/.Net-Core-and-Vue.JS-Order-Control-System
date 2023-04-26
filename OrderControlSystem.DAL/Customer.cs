using System.Collections.Generic;

#nullable disable

namespace OrderControlSystem.DAL
{
    public partial class Customer
    {
        public Customer()
        {
            Accounts = new HashSet<Account>();
            CustomerOrderItems = new HashSet<CustomerOrderItem>();
            CustomerOrders = new HashSet<CustomerOrder>();
        }

        public int CustomerId { get; set; }
        public string CompanyName { get; set; }
        public string CompanyFullName { get; set; }
        public string TaxNumber { get; set; }
        public string TaxAdministration { get; set; }
        public string Remark { get; set; }
        public int CurrencyType { get; set; }
        public int PartitionType { get; set; }
        public int Status { get; set; }
        public int Maturity { get; set; }
        public string CompanyCode { get; set; }

        public virtual ICollection<Account> Accounts { get; set; }
        public virtual ICollection<CustomerOrderItem> CustomerOrderItems { get; set; }
        public virtual ICollection<CustomerOrder> CustomerOrders { get; set; }
    }
}
