namespace OrderControlSystem.DAL.Concrete
{
    public class TreatmentTypeRepository : GenericRepository<TreatmentType, OrderControlContext>
    {
        OrderControlContext _context;
        public TreatmentTypeRepository(OrderControlContext context) : base(context)
        {
            _context = context;
        }
    }

}

