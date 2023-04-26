namespace OrderControlSystem.DAL.Concrete
{
    public class ReceiptDetailRepository : GenericRepository<ReceiptDetail, OrderControlContext>
    {
        OrderControlContext _context;
        public ReceiptDetailRepository(OrderControlContext context) : base(context)
        {
            _context = context;
        }

    }
}
