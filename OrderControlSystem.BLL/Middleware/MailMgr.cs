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
    public class MailMgr
    {
        static MailModelDto mailModelDto = new MailModelDto();
        static SmptModelDto smptModelDto = new SmptModelDto();
        SmptSettingDto smptSettingDto = new SmptSettingDto();
        public MailMgr() { }    
        public void MailSetting()
        {
            mailModelDto.From = new MailAddress(smptSettingDto.SmptEmailSetting);
            mailModelDto.To.Add(new MailAddress("berattozaydin@gmail.com"));
            mailModelDto.IsBodyHtml = true;
            
        }
        public void SmptSetting()
        {
            
            smptModelDto.Port = smptSettingDto.SmptPortSetting;
            smptModelDto.Host = "smtp.gmail.com";
            smptModelDto.EnableSsl = true;
            smptModelDto.UseDefaultCredentials = false;
            smptModelDto.Credentials = new NetworkCredential(smptSettingDto.SmptEmailSetting, smptSettingDto.SmptPasswordSetting);

        }
        public void MailSend()
        {
            MailSetting();
            SmptSetting();
            mailModelDto.Subject = "Test MAİL Model";
            mailModelDto.Body = "SEND MAİL MODEL TO BERATTOZAYDİN@GMAİL.COM";
            smptModelDto.Send(mailModelDto);
        }
    }
}
