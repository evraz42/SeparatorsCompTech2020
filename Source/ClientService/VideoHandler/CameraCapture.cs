using JetBrains.Annotations;
using OpenCvSharp;

namespace VideoHandler
{
    public sealed class CameraCapture
    {
        [NotNull]
        public  CvCapture Capture { get; }

        public CameraCapture(int cameraIndex)
        {
            try
            {
                Capture = new CvCapture(cameraIndex);
            }
            catch
            {

            }
        }
    }
}
