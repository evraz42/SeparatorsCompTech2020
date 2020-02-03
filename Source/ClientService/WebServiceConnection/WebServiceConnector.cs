using DatabaseController;
using DatabaseController.DataTypesInterfaces;
using JetBrains.Annotations;
using Moq;
using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace WebServiceConnection
{
    public class WebServiceConnector
    {
        [NotNull] private static readonly HttpClient Client = new HttpClient();
        [NotNull] private readonly byte[] _picture;
        [NotNull] private readonly Uri _uri = new Uri("http://localhost:51460/prediction");

        public WebServiceConnector([NotNull] byte[] data)
        {
            _picture = data;

            Client.DefaultRequestHeaders.Accept.Clear();
            Client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        public async void Send()
        {
            Device device = null;
            //try
            //{
            //    using var response = await GetResponse();
            //    response.EnsureSuccessStatusCode();
                //device = await GetResponseObject(response);
                //if(device == null)
                //{
                //    //logging
                //    return;
                //}
            //}
            //catch (HttpRequestException e)
            //{
            //    //logging
            //}

            device = new Device
            {
                name_device = "separator",
                number_device = 1,
                id_device = Guid.NewGuid()
            };
            device.flags.Add(
                new Flag
                {
                    TypeFlag = 0,
                    CurrentPosition = 1,
                    CurrentProbability = (float)0.95,
                    Positions = new float[] { 1, 2, 3, 4, 5, 6, 7 },
                    devices = (Device)device
                });
            
            device.flags.Add(
                new Flag
                {
                    TypeFlag = 1,
                    CurrentPosition = 1,
                    CurrentProbability = (float)0.95,
                    Positions = new float[] { 1, 2, 3, 4, 5, 6, 7 },
                    devices = (Device)device
                });

            new DatabaseSaver(device, _picture).Save();

        }

        [NotNull]
        private async Task<HttpResponseMessage> GetResponse()
        {
            using var content = new StringContent(
                JsonConvert.SerializeObject(_picture), 
                Encoding.UTF8,
                "application/json");

            return await Client.PostAsync(_uri, content);
        }

        [CanBeNull]
        private async Task<Device> GetResponseObject([NotNull]HttpResponseMessage response)
        {
            var responseBody = await response.Content.ReadAsStringAsync();
            var obj = JsonConvert.DeserializeObject(responseBody);
            if (!(obj is Device deviceObj))
            {
                return null;
            }
            return deviceObj;
        }
    }
}
