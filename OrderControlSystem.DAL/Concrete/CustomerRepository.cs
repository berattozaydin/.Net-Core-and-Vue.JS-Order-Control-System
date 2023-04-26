namespace OrderControlSystem.DAL.Concrete
{
    public class CustomerRepository : GenericRepository<Customer, OrderControlContext>
    {
        OrderControlContext tpHetrContext;
        public CustomerRepository(OrderControlContext tpHetrContext) : base(tpHetrContext)
        {
            this.tpHetrContext = tpHetrContext;
        }
    }
}

