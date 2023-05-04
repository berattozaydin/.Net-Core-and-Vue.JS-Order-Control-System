using OrderControlSystemService.Src;
using System.Threading;

namespace OrderControlSystemService
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;

        public Worker(ILogger<Worker> logger)
        {
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            var companyAmountService = new CompanyAmountService(stoppingToken);
            await companyAmountService.StartAsnyc(stoppingToken);
            var tcs = new TaskCompletionSource<bool>();
            stoppingToken.Register(s => ((TaskCompletionSource<bool>)s).SetResult(true), tcs);
            await tcs.Task;
            await companyAmountService.StopAsync(stoppingToken);
        }
    }
}