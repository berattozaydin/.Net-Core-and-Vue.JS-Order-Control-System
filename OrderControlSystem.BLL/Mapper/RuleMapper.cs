using AutoMapper;

namespace OrderControlSystem.BLL.Mapper
{
    public static class RuleMapper<TSource, TDestination>
    {
        private static AutoMapper.Mapper mymapper = new AutoMapper.Mapper(
            new MapperConfiguration(cfg => cfg.CreateMap<TSource, TDestination>()));

        public static TDestination Map(TSource source)
        {
            return mymapper.Map<TDestination>(source);
        }
    }
}

