using Emgu.CV;
using JetBrains.Annotations;
using System.Drawing.Imaging;
using System.IO;
using System.Threading;
using WebServiceConnection;

namespace VideoHandler
{
    public sealed class CameraControl
    {
        [NotNull]private readonly Capture _capture;
        private readonly int _msDelay = 60000;

        public CameraControl(string filename)
        {
            _capture = new Capture(filename);
        }

        public CameraControl(string filename, int msDelay)
        {
            _capture = new Capture(filename);
            _msDelay = msDelay;
        }

        public void Run()
        {
            var image = _capture.QueryFrame();
            using var stream = new MemoryStream();
            image.Bitmap?.Save(stream, ImageFormat.Jpeg);
            new WebServiceConnector(stream.ToArray()).Send();
            Thread.Sleep(_msDelay);
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
