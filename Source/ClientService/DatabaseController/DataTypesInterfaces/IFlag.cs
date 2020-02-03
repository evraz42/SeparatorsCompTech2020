using System;

namespace DatabaseController.DataTypesInterfaces
{
    public interface IFlag
    {
        int id { get; set; }

        Guid id_device { get; set; }

        DateTimeOffset time { get; set; }

        short type_flag { get; set; }

        string image_path { get; set; }

        int? current_position { get; set; }

        float current_probability { get; set; }

        Device devices { get; set; }

        bool IsValid();
    }
}
