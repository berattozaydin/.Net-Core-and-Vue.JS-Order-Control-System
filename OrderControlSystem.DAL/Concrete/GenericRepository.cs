using Microsoft.EntityFrameworkCore;
using OrderControlSystem.DAL.Abstract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace OrderControlSystem.DAL.Concrete
{
    public class GenericRepository<T, TContext> : IRepository<T> where T : class, new() where TContext : OrderControlContext, new()
    {
        private OrderControlContext context = new OrderControlContext();

        protected DbSet<T> _object;
        public GenericRepository(OrderControlContext context)
        {
            this.context = context;
            _object = context.Set<T>();

        }
        public void Add(T item)
        {

            _object.Add(item);
            var result = context.SaveChanges();

        }

        public void Delete(T item)
        {
            _object.Remove(item);
            context.SaveChanges();
        }

        public T GetById(object id)
        {
            return _object.Find(id);

        }

        public virtual List<T> List()
        {
            return _object.ToList();
        }

        public virtual List<T> List(Expression<Func<T, bool>> filter)
        {
            return _object.Where(filter).ToList();
        }
        public void Update(T item)
        {

            _object.Update(item);
            context.SaveChanges();
        }

    }
}