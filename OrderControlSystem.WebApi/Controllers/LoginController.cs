using Microsoft.AspNetCore.Mvc;
using OrderControlSystem.BLL.Managers;
using OrderControlSystem.DAL;


// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace OrderControlSystemWebApi.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class LoginController : Controller
    {
        AuthManager authManager;
        public LoginController(AuthManager authManager)
        {
            this.authManager = authManager;
        }
        [HttpPost]
        public async Task<IActionResult> LoginUser(Account account)
        {
            var result = await authManager.LoginUser(account);
            return Ok(result);

        }
    }
}

