using JetBrains.Annotations;

namespace DataTypes
{
    public class Flag
    {
        [NotNull] public int[] Coordinates { get; set; }
        [NotNull] public int Position { get; set; }
        [NotNull] public double Prediction { get; set; }
        [NotNull] public double[] PredictablePositions { get; set; }

    }
}
