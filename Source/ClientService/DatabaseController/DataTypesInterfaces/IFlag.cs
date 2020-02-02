using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
    }
}
