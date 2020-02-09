using System;

namespace DatabaseControllerCore.DataInterfaces
{
    public interface IFlag
    {
        int Id { get; set; }
        Guid IdDevice { get; set; }
        DateTime Time { get; set; }
        short TypeFlag { get; set; }
        float[] Positions { get; set; }
        string ImagePath { get; set; }
        int? CurrentPosition { get; set; }
        float CurrentProbability { get; set; }
    }
}
