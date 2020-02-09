using System;

namespace WebService.DataTypesInterfaces
{
    public class Flag : IFlag
    {
        public int Id { get; set; }

        public Guid IdDevice { get; set; }

        public DateTime Time { get; set; }

        public short TypeFlag { get; set; }

        public float[] Positions { get; set; }

        public string ImagePath { get; set; }

        public int? CurrentPosition { get; set; }

        public float CurrentProbability { get; set; }
    }
}
