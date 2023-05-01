using Microsoft.AspNetCore.Mvc.Filters;
using OrderControlSystem.Core;
using OrderControlSystem.BLL.Managers;
using System;
using System.Collections.Generic;
using System.Linq;

namespace OrderControlSystem.BLL.HandleMiddleware
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class LogHandleMiddleware : ActionFilterAttribute
    {
        Dictionary<string, object> contextDictionary = new Dictionary<string, object>();

        private string message;
        public LogHandleMiddleware(string message)
        {
            this.message = message;
        }
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            contextDictionary = (Dictionary<string, object>)context.ActionArguments;
            base.OnActionExecuting(context);
        }
        public override void OnActionExecuted(ActionExecutedContext context)
        {
            LogManager logManager = new LogManager();
            if (contextDictionary != null)
            {
                logManager.Add(new DAL.Log
                {
                    LogDescription = message + " " + "[ " + contextDictionary.ElementAt(0).Value + " ]",
                    LogMethod = context.HttpContext.Request.Method,
                    LogStatusCode = context.HttpContext.Response.StatusCode,
                    LogPath = context.HttpContext.Request.Path,
                    MachineName = Environment.MachineName.SubstringSafe(150),
                    CreatedDate = DateTime.Now
                });
            }
            else
            {
                logManager.Add(new DAL.Log
                {
                    LogDescription = message,
                    LogMethod = context.HttpContext.Request.Method,
                    LogStatusCode = context.HttpContext.Response.StatusCode,
                    LogPath = context.HttpContext.Request.Path,
                    MachineName = Environment.MachineName.SubstringSafe(150),
                    CreatedDate = DateTime.Now
                });

            }

        }
    }
}

