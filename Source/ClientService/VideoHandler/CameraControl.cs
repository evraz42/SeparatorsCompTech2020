using Emgu.CV;
using Guard;
using JetBrains.Annotations;
using System.Diagnostics;
using System.Drawing.Imaging;
using System.IO;
using WebServiceConnection;

namespace VideoHandler
{
    public sealed class CameraControl
    {
        [NotNull]private readonly Capture _capture;
        private readonly int _msDelay = 60000;

        public CameraControl([NotNull]string filename)
        {
            _capture = new Capture(filename);
        }

        public CameraControl([NotNull]string filename, int sDelay)
        {
            _capture = new Capture(filename);
            _msDelay = sDelay * 1000;
        }

        public void Run()
        {
            var timer = new Stopwatch();
            timer.Start();
            while (true)
            {
                using var image = _capture.QueryFrame();
                ThrowIf.Variable.IsNull(image, nameof(image));

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
