using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Net.Http;
using System.Text.Json;
using System.Text;
using System.Linq;
using OrderControlSystem.DAL;
using OrderControlSystem.Core.Models;
using OrderControlSystem.BLL.Models;

namespace OrderControlSystem.BLL.Managers
{
	public class MaterialQualityManager
    {
        OrderControlContext orderControlContext;
        Response<List<MaterialQuality>> response = new();
        public MaterialQualityManager(OrderControlContext orderControlContext)
		{
            this.orderControlContext = orderControlContext;
		}

        public ReturnResult Add(MaterialQuality item)
        {
            orderControlContext.MaterialQualities.Add(item);
            if (orderControlContext.SaveChanges() > 0)
            {
                var res = SetMaterialQualityL4(item);
                if(res.success == 1)
                {
                    return new ReturnResult
                    {
                        success = 1,
                        msg="Kalite Ekleme Başarılı."
                    };
                }
                else
                {
                    return new ReturnResult
                    {
                        msg = "Hata. Kalite Eklenemedi",
                        success = 0
                    };
                }
            }
            else
            {
                return new ReturnResult
                {
                    msg = "Hata. Kalite Eklenemedi",
                    success = 0
                };
            }
           
           
        }

        public void Delete(int item)
        {
            var deleteMaterialQuality = orderControlContext.MaterialQualities.FirstOrDefault(x=>x.MaterialQualityId==item);
            orderControlContext.MaterialQualities.Remove(deleteMaterialQuality);
            orderControlContext.SaveChanges();
        }

        public Response<List<MaterialQuality>> List()
        {
            response.Value = orderControlContext.MaterialQualities.ToList();
            return response;
        }

        public Response<List<MaterialQuality>> List(Expression<Func<MaterialQuality, bool>> filter)
        {
            response.Value = orderControlContext.MaterialQualities.Where(filter).ToList();
            return response;
        }

        public ReturnResult Update(MaterialQuality item)
        {
            var updateMaterialQuality = orderControlContext.MaterialQualities.FirstOrDefault(x=>x.MaterialQualityId==item.MaterialQualityId);
            
            updateMaterialQuality.Name = item.Name;
            updateMaterialQuality.Remark = item.Remark;
            updateMaterialQuality.Code = item.Code;
            updateMaterialQuality.CreatedDatetime = item.CreatedDatetime;
            updateMaterialQuality.UpdatedDatetime = item.UpdatedDatetime;
            orderControlContext.MaterialQualities.Update(updateMaterialQuality);
            orderControlContext.SaveChanges();
            var res = SetMaterialQualityL4(item);

            if (res.success == 1)
            {
                return new ReturnResult
                {
                    success = 1,
                    msg = "Kalite Güncelleme Başarılı"
                };
            }
            else
            {
                return new ReturnResult
                {
                    success = 0,
                    msg = "Kalite Güncelleme Başarısız"
                };
            }

        }
        public  ReturnResult SetMaterialQualityL4(MaterialQuality materialQuality)
        {
            var res = new ReturnResult { };
            var publishUri = new Uri("http:// localhost:5035 /app/api/materialQuality.php?addl4");
            using var httpClient = new HttpClient();

            string matQ = JsonSerializer.Serialize(new {
                MaterialQualityId=materialQuality.MaterialQualityId,
                Code=materialQuality.Code,
                Name=materialQuality.Name,
                Remark=materialQuality.Remark,
                UpdatedDatetime=materialQuality.UpdatedDatetime
            });

            var stringContent = new StringContent(matQ, Encoding.UTF8, "application/json");
            var result =  httpClient.PostAsync(publishUri, stringContent).Result;
            //var resco = result.Content.ReadFromJsonAsync<Result>().Result;
            if (result.IsSuccessStatusCode)
            {
                res = new ReturnResult
                {
                    success = 1,
                    Value = "Seviye 4 E Aktarım Başarılı"
                };
            }
            else
            {
                res = new ReturnResult
                {
                    success = 0,
                    Value = "Seviye 4 E Aktarım Başarısız"
                };
            }

            return res;
        } 
    }
}

