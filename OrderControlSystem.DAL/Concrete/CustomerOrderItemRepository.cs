namespace OrderControlSystem.DAL.Concrete
{
    public class CustomerOrderItemRepository : GenericRepository<CustomerOrderItem, OrderControlContext>
    {
        OrderControlContext tpHetrContext;
        public CustomerOrderItemRepository(OrderControlContext tpHetrContext) : base(tpHetrContext)
        {
            this.tpHetrContext = tpHetrContext;
        }
    }
}

