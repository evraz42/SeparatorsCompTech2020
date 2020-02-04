using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DatabaseControllerCore
{
    public partial class Flag
    {
        public int Id { get; set; }

        public Guid IdDevice { get; set; }

        public DateTime Time { get; set; }

        public short TypeFlag { get; set; }

        public float[] Positions { get; set; }

        public string ImagePath { get; set; }

        public int? CurrentPosition { get; set; }

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
