using System.Collections.Generic;
using VideoHandler;

class Program
{
    static void Main()
    {
        var cameraCaptures = new List<CameraCapture>(){ new CameraCapture(0) };
        var cameraControl = new CameraControl(cameraCaptures);
        cameraControl.Run();
    }
}