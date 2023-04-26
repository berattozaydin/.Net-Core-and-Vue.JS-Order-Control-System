using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using OrderControlSystem.BLL.HandleMiddleware;
using OrderControlSystem.BLL.Managers;
using OrderControlSystem.DAL;
using OrderControlSystem.DAL.Concrete;
using System.Text;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);


// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
/*builder.Services.AddSwaggerGen(c =>
{
    c.ResolveConflictingActions(apiDescriptions => apiDescriptions.First());
    c.IgnoreObsoleteActions();
    c.IgnoreObsoleteProperties();
    c.CustomSchemaIds(type => type.FullName);
});*/
builder.Services.AddLocalization();

/*------------------------------DB CONNECTION---------------------------------------*/

var level3DbConnection = builder.Configuration["ConnectionString:Level3Db"];
var level2DbConnection = builder.Configuration["ConnectionString:Level2Db"];

builder.Services.AddDbContext<OrderControlContext>(o =>
{
    o.UseMySQL(level3DbConnection);
    o.EnableSensitiveDataLogging();
});


builder.Services.AddControllersWithViews()
    .AddJsonOptions(options =>
    options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles

);
builder.Services.AddControllersWithViews()
    .AddJsonOptions(options =>
    options.JsonSerializerOptions.MaxDepth = int.MaxValue

);

/*-----------------------------LEVEL4-----------------------------------*/
builder.Services.AddScoped<Level4Manager>();
/*----------------------------------------------------------------------*/
/*-----------------------------LEVEL3-----------------------------------*/

builder.Services.AddScoped<CustomerOrderRepository>();
builder.Services.AddScoped<CustomerOrderManager>();

builder.Services.AddScoped<TreatmentTypeRepository>();
builder.Services.AddScoped<TreatmentTypeManager>();

builder.Services.AddScoped<ReceiptRepository>();
builder.Services.AddScoped<ReceiptManager>();

builder.Services.AddScoped<ReceiptDetailRepository>();
builder.Services.AddScoped<ReceiptDetailManager>();

builder.Services.AddScoped<CustomerOrderItemRepository>();
builder.Services.AddScoped<CustomerOrderItemManager>();

builder.Services.AddScoped<CustomerOrderItemStatusRepository>();
builder.Services.AddScoped<CustomerOrderItemStatusManager>();

builder.Services.AddScoped<CustomerRepository>();


builder.Services.AddScoped<MaterialQualityRepository>();
builder.Services.AddScoped<MaterialQualityManager>();

builder.Services.AddScoped<AccountRepository>();
builder.Services.AddScoped<AccountManager>();

builder.Services.AddSingleton<LogManager>();
builder.Services.AddScoped<CustomerOrderStatusManager>();
builder.Services.AddScoped<AuthManager>();
builder.Services.AddScoped<CustomerManager>();



var key = Encoding.ASCII.GetBytes("qweqewqeqwe123123123qwefdsagag");
builder.Services.AddAuthentication(x =>
{
    x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(x =>
{
    x.RequireHttpsMetadata = false;
    x.SaveToken = true;
    x.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateIssuer = false,
        ValidateAudience = false
    };

});

builder.Services.AddHttpClient();
builder.Services.AddCors(o => o.AddDefaultPolicy(p => p.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin()));

var app = builder.Build();
app.UseDefaultFiles();
app.UseStaticFiles();


if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    //app.UseSwagger();
    //app.UseSwaggerUI();
    app.UseCors();
}

app.UseCors(builder =>
{
    builder
    .AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader();

});
/*--------------------------------Middlewares-----------------------------------------*/


var wsOptions = new WebSocketOptions { KeepAliveInterval = TimeSpan.FromSeconds(60), ReceiveBufferSize = 4 * 1024 };
app.UseWebSockets(wsOptions);

app.UseMiddleware<ExceptionHandlingMiddleware>();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.UseEndpoints(endpoints => { endpoints.MapControllers(); });
app.MapControllers();


var delaySetting = int.Parse(builder.Configuration["Settings:WebSocketDelay"]);
app.Use(async (context, next) =>
{
    if (context.WebSockets.IsWebSocketRequest)
    {
        if (context.Request.Path.Value?.Substring(0, 4) == "/ws/")
        {
            using var webSocket = await context.WebSockets.AcceptWebSocketAsync();
            while (true)
            {
                if (context.Request.Path.Value.EndsWith(@"/customerOrders"))
                     await OrderControlSystem.BLL.HandleMiddleware.WebSocketManager.SendAsync(context, webSocket, context.Request.Path);

                await Task.Delay(delaySetting);
            }
        }
        else
        {
            context.Response.StatusCode = StatusCodes.Status400BadRequest;
        }
    }
    else
    {
        await next(context);
    }
});
await app.RunAsync();


