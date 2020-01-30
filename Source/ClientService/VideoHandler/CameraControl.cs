using System.Collections.Generic;
using System.Runtime.InteropServices;
using ClientService;
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
                    if (frameImageData != null)
                    {
                        var length = frameImageData.Height * frameImageData.Width;
                        var imageDataBytes = new byte[length];
                        Marshal.Copy(frameImageData.ImageData, imageDataBytes, 0, length);
                        new WebServiceConnector(imageDataBytes).Send();

                    }

                    Cv.WaitKey(1000);
                }
            }
        }
        
    }
}
