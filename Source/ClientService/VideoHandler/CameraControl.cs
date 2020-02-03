using Emgu.CV;
using JetBrains.Annotations;
using System.Diagnostics;
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

        public CameraControl(string filename, int sDelay)
        {
            _capture = new Capture(filename);
            _msDelay = sDelay * 1000;
        }

        public void Run()
        {
            Stopwatch timer = new Stopwatch();
            timer.Start();
            while (true)
            {
                var image = _capture.QueryFrame();
                if(image == null)
                {
                    //logging
                    continue;
                }

                if(timer.ElapsedMilliseconds < _msDelay)
                {
                    continue;
                }

                using var stream = new MemoryStream();
                image.Bitmap?.Save(stream, ImageFormat.Jpeg);
                new WebServiceConnector(stream.ToArray()).Send();
                timer.Restart();
            }
        }
    }
}
