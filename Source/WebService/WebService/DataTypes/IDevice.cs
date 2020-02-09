using System;

namespace WebService.DataTypesInterfaces
{
    public interface IDevice
    {
        Guid IdDevice { get; set; }
        string NameDevice { get; set; }
        int NumberDevice { get; set; }
        int[] FlagsPosition { get; set; }
    }
}
