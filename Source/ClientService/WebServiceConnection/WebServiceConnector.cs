using DatabaseController;
using JetBrains.Annotations;
using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using DatabaseController.DataTypesInterfaces;

namespace WebServiceConnection
{
    public class WebServiceConnector
    {
        [NotNull] private static readonly HttpClient Client = new HttpClient();
        [NotNull] private readonly byte[,] _picture;
        [NotNull] private readonly Uri _uri = new Uri("http://localhost:51460/prediction");

        public WebServiceConnector([NotNull] byte[,] data)
        {
            _picture = data;

            Client.DefaultRequestHeaders.Accept.Clear();
            Client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        public async Task Send()
        {
            IDevice device = null;
            try
            {
                using var response = await GetResponse();
                response.EnsureSuccessStatusCode();
                device = await GetResponseObject(response);
            }
            catch (HttpRequestException e)
            {

            }

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

        [NotNull]
        private async Task<IDevice> GetResponseObject([NotNull]HttpResponseMessage response)
        {
            var responseBody = await response.Content.ReadAsStringAsync();

            //var separator = Validator.Validate(JsonConvert.DeserializeObject(responseBody));
            return null;
        }
    }
}
