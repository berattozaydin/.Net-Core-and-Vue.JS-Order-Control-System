using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.HandleMiddleware;
using OrderControlSystem.BLL.Managers;
using OrderControlSystem.BLL.Models;
using OrderControlSystem.DAL;
using OrderControlSystem.DAL.Models;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace OrderControlSystemWebApi.Controllers
{

    [Route("api/[controller]/[action]")]
    [ApiController]

    public class AccountController : Controller
    {
        //AccountService accountService;
        AccountManager accountManager;
        public AccountController(AccountManager accountManager)
        {
            this.accountManager = accountManager;
        }
        [HttpGet]
        public IActionResult GetAllAccount()
        {
            var list = accountManager.List();
            return Ok(list);
        }
        [HttpPost]
        [LogHandleMiddleware("Kullanıcı Eklendi")]
        public ReturnResult CreateAccount(Account account)
        {
            var list = accountManager.CreateAccount(account);
            return list;
        }
        [HttpPost]
        [LogHandleMiddleware("Kullanıcı Güncellendi")]
        public ReturnResult UpdateAccount(AccountDto accountDto)
        {
            var list = accountManager.UpdateAccount(accountDto);
            return list;
        }
        [HttpPost]
        [LogHandleMiddleware("Kullanıcı Silindi")]
        public ReturnResult DeleteAccount(string userName)
        {
            var res = accountManager.DeleteAccount(userName);
            return res;
        }
    }
}

