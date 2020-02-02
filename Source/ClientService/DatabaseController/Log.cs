namespace DatabaseController
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("public.logs")]
    public partial class Log
    {
        public long id { get; set; }

        public DateTimeOffset time { get; set; }

        [Required]
        public string level { get; set; }

        [Required]
        public string message { get; set; }
    }
}
