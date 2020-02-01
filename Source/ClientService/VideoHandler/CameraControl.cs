using System.Collections.Generic;
using System.Runtime.InteropServices;
using WebServiceConnection;
using JetBrains.Annotations;
using OpenCvSharp;

namespace VideoHandler
{
    public sealed class CameraControl
    {
        [NotNull]
        [ItemNotNull]
        private readonly IReadOnlyList<CameraCapture> _cameraCaptures;

        public CameraControl([NotNull][ItemNotNull]IReadOnlyList<CameraCapture> cameraCaptures)
        {
            _cameraCaptures = cameraCaptures;
        }
        
        public  void Run()
        {
            while (true)
            {
                foreach (var capture in _cameraCaptures)
                {
                    capture.Capture.GrabFrame();
                    var frameImageData = capture.Capture.RetrieveFrame();
                    if (frameImageData == null)
                    {
                        return;
                    }
                    
                    var length = frameImageData.Height * frameImageData.Width;
                    var imageDataBytes = new byte[length];
                    Marshal.Copy(frameImageData.ImageData, imageDataBytes, 0, length);

                    var imageBytes = GetTwoDimensionalArray(imageDataBytes, frameImageData.Width, frameImageData.Height);
                    new WebServiceConnector(imageBytes).Send();

                    Cv.WaitKey(1000);
                }
            }
        }

        [NotNull]
        private static T[,] GetTwoDimensionalArray<T>([NotNull] T[] array, int width, int height)
        {
            var resultArray = new T[height, width];
            for (var i = 0; i < height; i++)
            {
                for (var j = 0; j < width; j++)
                {
                    resultArray[i, j] = array[i * width + j];
                }
            }
            return resultArray;
        }
    }
}
