using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using OrderControlSystem.DAL;
using Result = OrderControlSystem.Core.Models.Result;

namespace OrderControlSystem.BLL.Managers
{
    public class AuthManager
    {
        OrderControlContext orderControlSystemContext;
        public AuthManager(OrderControlContext orderControlSystemContext)
        {
            this.orderControlSystemContext = orderControlSystemContext;
        }
        public async Task<OrderControlSystem.Core.Models.Result> LoginUser(Account searchAccount)
        {
            var account = await orderControlSystemContext.Accounts.FirstOrDefaultAsync(x => x.Username == searchAccount.Username && x.Password == ToSha256(searchAccount.Password));

            if (account == null)
            {
                return new Result
                {
                    IsSuccess = false,
                    msg = "Kullanıcı adı veya şifre yanlış"
                };
            }
            var log = new Log()
            {
                CreatedDate = DateTime.Now,
                LogDescription = ("Kullanıcı Giriş Yaptı : " + searchAccount.Username),
                LogMethod = "AuthManager/LoginUser",
                LogStatusCode = 200,
                MachineName = Environment.MachineName,
                LogPath = "AuthController/Login"
            };
            await orderControlSystemContext.Logs.AddAsync(log);
            await orderControlSystemContext.SaveChangesAsync();
            var key = Encoding.ASCII.GetBytes("qweqewqeqwe123123123qwefdsagag");
            var tokenHandler = new JwtSecurityTokenHandler();
            var expires = DateTime.UtcNow.AddHours(5);
            var descriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {

                    new Claim(ClaimTypes.Name, account.Username.ToString()),
                    new Claim(ClaimTypes.Role, account.Role.ToString()),
                    new Claim("UserId", account.Id.ToString())
                }),
                Expires = expires,
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var securityToken = tokenHandler.CreateToken(descriptor);
            var token = tokenHandler.WriteToken(securityToken);

            var result = new OrderControlSystem.Core.Models.Result
            {
                IsSuccess = true,
                msg = $"Hoşgeldin {account.Name} {account.LastName}",
                Value = new
                {
                    Token = token,
                    Expires = expires,
                    Id = account.Id,
                    Username = account.Username,
                    Name = account.Name,
                    LastName = account.LastName,
                    Role = account.Role
                }
            };

            return result;
        }
        private static string ToSha256(string value)
        {
            StringBuilder stringBuilder = new StringBuilder();
            using (var hash = SHA256.Create())
            {
                Encoding encoding = Encoding.UTF8;
                byte[] result = hash.ComputeHash(encoding.GetBytes(value));
                foreach (byte b in result)
                    stringBuilder.Append(b.ToString("x2"));
            }
            return stringBuilder.ToString();
        }

    }
}

