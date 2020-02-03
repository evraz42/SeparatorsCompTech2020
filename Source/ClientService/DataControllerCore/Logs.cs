using System;
using System.Collections.Generic;

namespace DataControllerCore
{
    public partial class Logs
    {
        public long Id { get; set; }
        public DateTime Time { get; set; }
        public string Level { get; set; }
        public string Message { get; set; }
    }
}
