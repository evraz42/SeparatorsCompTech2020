using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

using DatabaseController.DataTypesInterfaces;

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
    }
}
