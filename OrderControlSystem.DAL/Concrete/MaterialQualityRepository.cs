namespace OrderControlSystem.DAL.Concrete
{
    public class MaterialQualityRepository : GenericRepository<MaterialQuality, OrderControlContext>
    {
        OrderControlContext tpHetrContext;
        public MaterialQualityRepository(OrderControlContext tpHetrContext) : base(tpHetrContext)
        {
            this.tpHetrContext = tpHetrContext;
        }
    }
}

