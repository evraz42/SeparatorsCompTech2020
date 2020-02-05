using Newtonsoft.Json;
using System.Drawing;
using System.IO;
using System.Web.Http;
using WebService.DataTypesInterfaces;

namespace WebService.Controllers
{
    public class PredictionController : ApiController
    {
        // POST: api/Prediction
        public string Post([FromBody]byte[] data)
        {
            if(data == null)
            {
                return null;
            }

            using var stream = new MemoryStream(data);
            var image = Image.FromStream(stream);

            //ml processing

            image.Save("path");

            ML.Model model = new ML.Model("path");
            model.Run();
            Device outData;
            // TODO
            // Надо outData заполнить

            return JsonConvert.SerializeObject(data);
        }
    }
}
