using DatabaseController.DataTypesInterfaces;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DatabaseController
{
    [Table("public.flags")]
    public partial class Flag : IFlag
    {
        public int id { get; set; }

        public Guid id_device { get; set; }

        public DateTimeOffset time { get; set; }

        public short type_flag { get; set; }

        [Required]
        public string image_path { get; set; }

        public int? current_position { get; set; }

        public float current_probability { get; set; }

        public virtual Device devices { get; set; }

        public bool IsValid()
        {
            return current_position == null ? false : true;
        }

        public override bool Equals(object obj)
        {
            if (!(obj is Flag flagObj))
            {
                return false;
            }

            if (!flagObj.id_device.Equals(id_device))
            {
                return false;
            }
            if (flagObj.type_flag != type_flag)
            {
                return false;
            }
            if (flagObj.current_position != current_position)
            {
                return false;
            }

            return true;
        }
    }
}
