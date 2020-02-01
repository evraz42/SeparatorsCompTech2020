using JetBrains.Annotations;
using System.Collections.Generic;

namespace DataTypes
{
    public interface ISeparator
    {
        [NotNull] byte[,] Picture { get; set; }
        int FlagType { get; set; }
        [NotNull] double[] PositionProbabilities { get; set; }
        int ActualPosition{ get; set; }
        double ActualPositionProbability { get; set; }
    }
}
