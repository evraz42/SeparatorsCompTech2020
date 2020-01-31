using JetBrains.Annotations;
using System.Collections.Generic;

namespace DataTypes
{
    public class Separator
    {
        [NotNull] [ItemNotNull] public List<Flag> Flags { get; set; }
        [NotNull] public byte[,] Picture { get; set; }

        public void CreateSeparator()
        {

        }
    }
}
