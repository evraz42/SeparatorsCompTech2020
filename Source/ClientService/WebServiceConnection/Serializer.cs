using Newtonsoft.Json;

namespace ClientService
{
    internal static class Serializer
    {
        internal static string Serialize(object data)
        {
            return JsonConvert.SerializeObject(data.GetType(), Formatting.Indented,
                new JsonSerializerSettings
                {
                    TypeNameHandling = TypeNameHandling.Objects,
                });
        }

        internal static object Deserialize(string jsonString)
        {
            return JsonConvert.DeserializeObject(jsonString,
                new JsonSerializerSettings
                {
                    TypeNameHandling = TypeNameHandling.Auto
                });
        }
    }
}
