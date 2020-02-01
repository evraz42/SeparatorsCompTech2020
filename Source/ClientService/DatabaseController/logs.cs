namespace DatabaseController
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("public.logs")]
    public partial class Logs
    {
        public long id { get; set; }

        public DateTimeOffset time { get; set; }

        [Required]
        public string level { get; set; }

        [Required]
        public string message { get; set; }
    }
}
