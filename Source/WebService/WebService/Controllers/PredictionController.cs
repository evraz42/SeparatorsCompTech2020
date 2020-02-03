using Newtonsoft.Json;
using System.Drawing;
using System.IO;
using System.Web.Http;

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
            if(image == null)
            {
                return null;
            }

            //ml processing
            return JsonConvert.SerializeObject(data);
        }
    }
}
