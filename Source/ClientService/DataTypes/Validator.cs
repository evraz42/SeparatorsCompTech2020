using JetBrains.Annotations;

namespace DataTypes
{
    public static class Validator
    {
        public static Separator Validate([NotNull] object data)
        {
            if (!(data is Separator))
            {
                return null;
            }

            if(!ValidateSeparator((Separator)data))
            {
                return null;
            }

            return (Separator)data;
        }

        public static bool ValidateSeparator([NotNull] Separator separator)
        {
            foreach(var flag in separator.Flags)
            {
                if (flag.Position == 0)
                {
                    return false;
                }
            }
            return true;
        }
    }
}
