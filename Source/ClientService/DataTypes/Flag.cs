using JetBrains.Annotations;

namespace DataTypes
{
    public class Flag
    {
        [NotNull] public int[] Coordinates { get; }
        [NotNull] public int Position { get; }
        [NotNull] public double Prediction { get; }
        [NotNull] public double[] PredictablePositions { get; }

    }
}
