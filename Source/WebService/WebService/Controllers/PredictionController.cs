using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Newtonsoft.Json;

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

            //ml processing
            return JsonConvert.SerializeObject(data);
        }
    }
}
