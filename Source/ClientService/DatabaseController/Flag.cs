namespace DatabaseController
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("public.flags")]
    public partial class Flag
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
    }
}
