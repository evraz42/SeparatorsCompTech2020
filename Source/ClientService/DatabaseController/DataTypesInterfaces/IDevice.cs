using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace DatabaseController.DataTypesInterfaces
{
    public interface IDevice
    {
        Guid id_device { get; set; }

        string name_device { get; set; }

        int number_device { get; set; }
        ICollection<Flag> flags { get; set; }

        [NotMapped]
        int[] FlagsPosition { get; set; }

        bool IsValid();
    }
}
