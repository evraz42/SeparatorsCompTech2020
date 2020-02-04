using System;
using JetBrains.Annotations;

namespace Guard
{
    internal static class ThrowHelper
    {
        public static void ThrowVariableNullException([NotNull] string variableName)
        {
            throw new ArgumentNullException($"Variable {variableName} is null");
        }
    }
}