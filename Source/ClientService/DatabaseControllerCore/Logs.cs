using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DatabaseControllerCore
{
    public partial class Logs
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("time", TypeName = "timestamp with time zone")]
        public DateTime Time { get; set; }

        [Required]
        [Column("level")]
        public string Level { get; set; }

        [Required]
        [Column("message")]
        public string Message { get; set; }
    }
}
