namespace OrderControlSystem.DAL.Concrete
{
    public class AccountRepository : GenericRepository<Account, OrderControlContext>
    {
        OrderControlContext tpHetrContext;
        public AccountRepository(OrderControlContext tpHetrContext) : base(tpHetrContext)
        {
            this.tpHetrContext = tpHetrContext;
        }
    }
}

