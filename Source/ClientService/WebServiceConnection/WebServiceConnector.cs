using DataTypes;
using JetBrains.Annotations;
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace ClientService
{
    public class WebServiceConnector
    {
        [NotNull] private static readonly HttpClient _client = new HttpClient();
        [NotNull] private readonly byte[] _picture;
        [NotNull] private readonly Uri _uri = new Uri("http://localhost/1004");

        public WebServiceConnector([NotNull] byte[] data)
        {
            _picture = data;

            _client.DefaultRequestHeaders.Accept.Clear();
            _client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        public async Task Send()
        {
            Separator separator;
            try
            {
                using var response = await GetResponse();
                response.EnsureSuccessStatusCode();
                separator = await GetResponseObject(response);
            }
            catch (HttpRequestException e)
            {

            }

            //new DatabaseController(separator).Save();

        }

        [NotNull]
        private async Task<HttpResponseMessage> GetResponse()
        {
            using var content = new StringContent(
                Serializer.Serialize(_picture).ToString(), 
                Encoding.UTF8,
                "application/json");

            return await _client.PutAsync(_uri, content);
        }

        [NotNull]
        private async Task<Separator> GetResponseObject([NotNull]HttpResponseMessage response)
        {
            var responseBody = await response.Content.ReadAsStringAsync();

            var separator = Validator.Validate(Serializer.Deserialize(responseBody));
            separator.Picture = _picture;
            return separator;
        }
    }
}
