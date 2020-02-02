using Emgu.CV;
using JetBrains.Annotations;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Threading;
using WebServiceConnection;

namespace VideoHandler
{
    public sealed class CameraControl
    {
        [NotNull]private readonly Capture _capture;

        public CameraControl(string filename)
        {
            _capture = new Capture(filename);
        }

        public void Run()
        {
            //int i = 0;
           
            var image = _capture.QueryFrame();
            using var stream = new MemoryStream();
            image.Bitmap?.Save(stream, ImageFormat.Jpeg);
            var imageBytes = stream.ToArray();

            //Image.FromStream(stream).Save($"C:/Users/kindl/Downloads/{i++}.png");
            Thread.Sleep(60000);
            new WebServiceConnector(imageBytes).Send();
        }
    }
    
    //    [NotNull]
    //    private static T[,] GetTwoDimensionalArray<T>([NotNull] T[] array, int width, int height)
    //    {
    //        var resultArray = new T[height, width];
    //        for (var i = 0; i < height; i++)
    //        {
    //            for (var j = 0; j < width; j++)
    //            {
    //                resultArray[i, j] = array[i * width + j];
    //            }
    //        }
    //        return resultArray;
    //    }
    //}
}
