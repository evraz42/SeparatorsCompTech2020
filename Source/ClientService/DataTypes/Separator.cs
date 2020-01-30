using JetBrains.Annotations;
using System.Collections.Generic;

namespace DataTypes
{
    public class Separator
    {
        [NotNull] [ItemNotNull] public readonly List<Flag> Flags;
        [NotNull] public byte[] Picture;

        public void CreateSeparator()
        {

        }
    }
}
