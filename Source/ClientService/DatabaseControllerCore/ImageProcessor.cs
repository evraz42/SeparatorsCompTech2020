using System.Drawing;
using JetBrains.Annotations;

namespace DatabaseControllerCore
{
    internal static class ImageProcessor
    {
        internal static void DrawRectangle([NotNull]Image image, int a, int b, int c, int d)
        {
            using var g = Graphics.FromImage(image);
            g.DrawRectangle(new Pen(Color.Red, 3), new Rectangle(a, b, c, d));
        }
    }
}
