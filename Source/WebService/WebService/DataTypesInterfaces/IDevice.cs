using System;
using System.Collections.Generic;

namespace WebService.DataTypesInterfaces
{
    public interface IDevice
    {
        Guid IdDevice { get; set; }

        string NameDevice { get; set; }

        int NumberDevice { get; set; }

        ICollection<IFlag> Flags { get; set; }  //HashSet in realization

        int[] FlagsPosition { get; set; }
    }
}
