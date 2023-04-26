using System;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using OrderControlSystem.DAL;
using OrderControlSystem.Core.Models;

namespace OrderControlSystem.Managers
{
    public class LogManager
    {
        private readonly OrderControlContext orderControlContext;
        public LogManager()
        {
            this.orderControlContext = new OrderControlContext();

        }
        public async void Add(Log log)
        {
            await orderControlContext.Logs.AddAsync(log);
             await orderControlContext.SaveChangesAsync();
        }
        public async Task<Result> FetchLogData()
        {

            /* var res = await tpHetrL3Context.Logs.Select(x=>new LogWithDetail
             {
                 Id=x.Id,
                 LogDescription=x.LogDescription,
                 LogMethod=x.LogMethod,
                 LogPath=x.LogPath,
                 LogStatusCode=x.LogStatusCode,
                 MachineName=x.MachineName
             } ).ToListAsync();
             res = LogWithDetails()*/
            var res = await orderControlContext.Logs.ToListAsync();
            var result = new Result { IsSuccess = true, Value =  res  };
            return result;
        }
        /*private IQueryable<DAL.Models.LogWithDetail> LogWithDetails()
        {
            return;
        }*/


    }
}

