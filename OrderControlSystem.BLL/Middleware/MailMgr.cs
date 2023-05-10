using OrderControlSystem.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace OrderControlSystem.BLL.Middleware
{
    public static class MailMgr
    {
        static MailModelDto mailModelDto = new MailModelDto();
        static SmptModelDto smptModelDto = new SmptModelDto();
        static SmptSettingDto smptSettingDto = new SmptSettingDto();
        public static void MailSetting()
        {
            mailModelDto.From = new MailAddress(smptSettingDto.SmptEmailSetting);
            mailModelDto.To.Add(new MailAddress("berattozaydin@gmail.com"));
            mailModelDto.IsBodyHtml = true;
            
        }
        public static  void SmptSetting()
        {
            
            smptModelDto.Port = smptSettingDto.SmptPortSetting;
            smptModelDto.Host = "smtp.gmail.com";
            smptModelDto.EnableSsl = true;
            smptModelDto.UseDefaultCredentials = false;
            smptModelDto.Credentials = new NetworkCredential(smptSettingDto.SmptEmailSetting, smptSettingDto.SmptPasswordSetting);

        }
        public static void MailSend()
        {
            MailSetting();
            SmptSetting();
            mailModelDto.Subject = "Test MAİL Model";
            mailModelDto.Body = "SEND MAİL MODEL TO BERATTOZAYDİN@GMAİL.COM";
            smptModelDto.Send(mailModelDto);
        }
    }
}
