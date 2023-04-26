using ClosedXML.Report;
using System.IO;

namespace OrderControlSystem.BLL
{
    public static class Helpers
    {
        public static byte[] GetExcelFileFromTemplate(string templateName, object data)
        {
            byte[] excelFile;
            var template = new XLTemplate($@"ExcelReportTemplates/{templateName}.xlsx");

            template.AddVariable(data);
            template.Generate();

            using (MemoryStream memoryStream = new MemoryStream())
            {
                template.Workbook.SaveAs(memoryStream);
                excelFile = memoryStream.ToArray();
            }
            return excelFile;
        }
    }
}
