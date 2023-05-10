using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace OrderControlSystem.Core.Models
{
    public class MailModelDto :MailMessage
    {
        
    }
    public class SmptModelDto : SmtpClient
    {
        
    }
    public class SmptSettingDto
    {
        public int SmptPortSetting { get; set; } = 587;
        public string SmptPasswordSetting { get; set; } = "ftukvhvwugbbpovp";
        public string SmptEmailSetting { get; set; } = "beratzeus@gmail.com";
    }
}
