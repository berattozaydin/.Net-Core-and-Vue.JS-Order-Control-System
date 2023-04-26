using Microsoft.AspNetCore.Http;
using OrderControlSystem.BLL.Models;
using OrderControlSystem.Core;
using OrderControlSystem.DAL;
using System;
using System.Net;
using System.Text.Json;
using System.Threading.Tasks;

namespace OrderControlSystem.BLL.HandleMiddleware
{
    public class ExceptionHandlingMiddleware
    {
        public RequestDelegate _requestDelegate;

        public ExceptionHandlingMiddleware(RequestDelegate requestDelegate)
        {
            _requestDelegate = requestDelegate;

        }
        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _requestDelegate(context);
            }
            catch (Exception ex)
            {
                await HandleException(context, ex);
            }
        }
        private async Task HandleException(HttpContext context, Exception ex)
        {

            var log = new Log()
            {
                LogDescription = ex.Message,
                LogMethod = context.Request.Method.SubstringSafe(250),
                LogPath = context.Request.Path.ToString().SubstringSafe(250),
                LogStatusCode = context.Response.StatusCode,
                MachineName = Environment.MachineName,
                CreatedDate = DateTime.Now,
            };
            OrderControlContext orderControlContext = new OrderControlContext();
            await orderControlContext.Logs.AddAsync(log);
            await orderControlContext.SaveChangesAsync();

            var res = new ReturnResult
            {
                msg = "Program Hatası",
                success = 0,
                objectValue = ex.StackTrace,
                Value = ex.Message
            };
            var errorMessage = JsonSerializer.Serialize(res);
            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
            await context.Response.WriteAsync(errorMessage);
        }
    }
}
