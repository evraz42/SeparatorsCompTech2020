using DatabaseController.DataTypesInterfaces;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DatabaseController
{
    [Table("public.devices")]
    public partial class Device : IDevice
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Device()
        {
            flags = new HashSet<Flag>();
        }

        [Key]
        public Guid id_device { get; set; }

        [Required]
        public string name_device { get; set; }

        public int number_device { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Flag> flags { get; set; }

        [NotMapped]
        public int[] FlagsPosition { get; set; }

        public bool IsValid()
        {
            foreach(var flag in flags)
            {
                if(!flag.IsValid())
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

            if (!deviceObj.name_device.Equals(name_device))
            {
                return false;
            }
            if (deviceObj.number_device != number_device)
            {
                return false;
            }
            if(deviceObj.flags.Count != flags.Count)
            {
                return false;
            }

            foreach(var flag in deviceObj.flags)
            {
                if(!flags.Contains(flag))
                {
                    return false;
                }
            }
            return true;
        }
    }
}
