using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DatabaseController.DataTypesInterfaces;

namespace DatabaseController
{
    [Table("public.logs")]
    public partial class Log : ILog
    {
        public long id { get; set; }

        public DateTimeOffset time { get; set; }

        [Required]
        public string level { get; set; }

        [Required]
        public string message { get; set; }
    }
}
