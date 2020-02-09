using System;
using System.Collections.Generic;

namespace WebService.DataTypesInterfaces
{
    public class Device : IDevice
    {
        public Device()
        {
            Flags = new HashSet<Flag>();
        }

        public Guid IdDevice { get; set; }

        public string NameDevice { get; set; }

        public int NumberDevice { get; set; }
        public virtual ICollection<Flag> Flags { get; set; }
        public int[] FlagsPosition { get; set; }
    }
}
