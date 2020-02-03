using System;

namespace DatabaseController.DataTypesInterfaces
{
    public interface ILog
    {
        long id { get; set; }

        DateTimeOffset time { get; set; }

        string level { get; set; }

        string message { get; set; }
    }
}
