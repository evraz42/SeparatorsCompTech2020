using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebService.DataTypesInterfaces
{
    [Table("public.devices")]
    public partial class Device
    {
        public Device()
        {
            Flags = new HashSet<Flag>();
        }

        public Guid IdDevice { get; set; }

        [Required]
        [Column("name_device")]
        public string NameDevice { get; set; }

        [Column("number_device")]
        public int NumberDevice { get; set; }

        public virtual ICollection<Flag> Flags { get; set; }

        [NotMapped]
        [NotNull]
        public int[] FlagsPosition { get; set; }

        public bool IsValid()
        {
            foreach (var flag in Flags)
            {
                if (!flag.IsValid())
                {
                    return false;
                }
            }
            return true;
        }

        public override bool Equals(object obj)
        {
            if (!(obj is Device deviceObj))
            {
                return false;
            }

            if (!deviceObj.NameDevice.Equals(NameDevice))
            {
                return false;
            }
            if (deviceObj.NumberDevice != NumberDevice)
            {
                return false;
            }
            if (deviceObj.Flags.Count != Flags.Count)
            {
                return false;
            }

            foreach (var flag in deviceObj.Flags)
            {
                if (!Flags.Contains(flag))
                {
                    return false;
                }
            }
            return true;
        }
    }
}
