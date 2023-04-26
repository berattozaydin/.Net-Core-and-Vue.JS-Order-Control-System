using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Security.Cryptography;
using System.Text;
using OrderControlSystem.BLL.Models;
using OrderControlSystem.Core.Models;
using OrderControlSystem.DAL;
using OrderControlSystem.DAL.Models;

namespace OrderControlSystem.Managers
{
	public class AccountManager
	{
        OrderControlContext orderControlContext;
        
		public AccountManager(OrderControlContext orderControlContext)
		{
            this.orderControlContext = orderControlContext;
		}

        public ReturnResult CreateAccount(Account item)
        {
            var CheckAccount = orderControlContext.Accounts.FirstOrDefault(x => x.Username == item.Username);
            if (CheckAccount != null)
            {
                return new ReturnResult
                {
                    msg = "Hata. Kullanıcı zaten mevcut.",
                    success = 0
                };

            }
            else
            {
                item.Password = ToSha256(item.Password);
                orderControlContext.Accounts.Add(item);
                if ((orderControlContext.SaveChanges()) > 0)
                {
                    return new ReturnResult
                    {
                        success = 1,
                        msg = "Kullanıcı Eklendi."
                    };
                }
                else
                {
                    return new ReturnResult
                    {
                        success = 0,
                        msg = "Hata. Kullanıcı Eklenemedi."
                    };
                }
            }

            
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
        public ReturnResult DeleteAccount(string userName)
        {
            var res = orderControlContext.Accounts.FirstOrDefault(x => x.Username == userName);
            if(res == null)
            {
                return new ReturnResult
                {
                    success = 0,
                    msg=("  Hata. Kullanıcı Bulunamadı. " + userName)
                };
            }
            else
            {
                if(res.Role==1)
                {
                    return new ReturnResult
                    {
                        success = 0,
                        msg="  Hata. Kullanıcıyı silme izniniz yok."
                    };
                }
                else
                {
                    orderControlContext.Accounts.Remove(res);
                    if (orderControlContext.SaveChanges() > 0)
                    {
                        return new ReturnResult
                        {
                            success = 1,
                            msg = "Kullanıcı Silindi"
                        };
                    }
                    else
                    {
                        return new ReturnResult
                        {
                            success = 0,
                            msg ="  Hata. Kullanıcı Silinemedi."
                        };
                    }
                }
            }

        }

        public Account GetById(int id)
        {
            throw new NotImplementedException();
        }

        public Response<List<Account>> List()
        {
            Response<List<Account>> response = new();
            var list = orderControlContext.Accounts.ToList();
            foreach(var item in list)
            {
                item.Customer = orderControlContext.Customers.FirstOrDefault(x=>x.CustomerId==item.CustomerId);
            }
            response.Value = list;
            return response;
        }

        public Response<List<Account>> List(Expression<Func<Account, bool>> filter)
        {
            Response<List<Account>> response = new();
            var list = orderControlContext.Accounts.Where(filter).ToList();
            foreach (var item in list)
            {
                item.Customer = orderControlContext.Customers.FirstOrDefault(x => x.CustomerId == item.CustomerId);
            }
            response.Value = list;
            return response;

        }

        public ReturnResult UpdateAccount(AccountDto item)
        {
            var updatedAccount = orderControlContext.Accounts.FirstOrDefault(x => x.Username == item.Username);
            if(updatedAccount == null)
            {
                return new ReturnResult
                {
                    success=0,
                    msg="  Hata. Kullanıcı Bulunamadı."
                };
            }
            else
            {
                updatedAccount.Username = item.Username;
                updatedAccount.Password = item.Password;
                updatedAccount.Email = item.Email;
                updatedAccount.UpdateDati = DateTime.Now;
                updatedAccount.CustomerId = item.CustomerId;
                updatedAccount.IsActive = item.IsActive;
                updatedAccount.Name = item.Name;
                updatedAccount.Role = item.Role;
                updatedAccount.LastName = item.LastName;
                updatedAccount.PhoneNumber = item.PhoneNumber;
                orderControlContext.Accounts.Update(updatedAccount);
                if ((orderControlContext.SaveChanges()) > 0)
                {
                    return new ReturnResult
                    {
                        success=1,
                        msg="Kullanıcı Başarıyla Güncellendi."
                    };
                }
                else
                {
                    return new ReturnResult
                    {
                        success=0,
                        msg="  Hata. Kullanıcı Güncellenemedi."
                    };
                }
            }
            
            
        }
    }
}

