using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DatabaseControllerCore
{
    [Table("public.flags")]
    public partial class Flag
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("id_device")]
        public Guid IdDevice { get; set; }

        [Column("time", TypeName = "timestamp with time zone")]
        public DateTime Time { get; set; }

        [Column("type_flag")]
        public short TypeFlag { get; set; }

        [Required]
        [Column("positions")]
        public float[] Positions { get; set; }

        [Required]
        [Column("image_path")]
        public string ImagePath { get; set; }

        [Column("current_position")]
        public int? CurrentPosition { get; set; }

        [Column("current_probability")]
        public float CurrentProbability { get; set; }

        public virtual Device IdDeviceNavigation { get; set; }

        public bool IsValid()
        {
            return CurrentPosition != null;
        }

        public override bool Equals(object obj)
        {
            if (!(obj is Flag flagObj))
            {
                return false;
            }

            if (!flagObj.IdDevice.Equals(IdDevice))
            {
                return false;
            }
            if (flagObj.TypeFlag != TypeFlag)
            {
                return false;
            }
            if (flagObj.CurrentPosition != CurrentPosition)
            {
                return false;
            }

            return true;
        }
    }
}
