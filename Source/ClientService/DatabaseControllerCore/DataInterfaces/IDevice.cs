using System;

namespace DatabaseControllerCore.DataInterfaces
{
    public interface IDevice
    {
        Guid IdDevice { get; set; }
        string NameDevice { get; set; }
        int NumberDevice { get; set; }
        int[] FlagsPosition { get; set; }
    }
}
