namespace OrderControlSystem.DAL.Concrete
{
    public class CustomerOrderItemStatusRepository : GenericRepository<CustomerOrderItemStatus, OrderControlContext>
    {
        OrderControlContext tpHetrContext;
        public CustomerOrderItemStatusRepository(OrderControlContext tpHetrContext) : base(tpHetrContext)
        {
            this.tpHetrContext = tpHetrContext;
        }
    }
}

