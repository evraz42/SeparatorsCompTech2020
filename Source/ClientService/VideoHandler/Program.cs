using System;
using System.IO;

namespace VideoHandler
{
    class Program
    {
        static void Main(string[] args)
        {
            if(args.Length < 1 || args.Length > 2)
            {
                Console.WriteLine("Usage: ProgramName.exe <File/camera path> [period (sec)]");
            }
            if(!File.Exists(args[0]))
            {
                Console.WriteLine("Error: File does not exist!");
            }

            CameraControl cameraControl;
            if (int.TryParse(args[1], out var secDelay)
            {
                cameraControl = new CameraControl("C:/Users/kindl/Downloads/asds.avi", secDelay);
            }
            else
            {
                cameraControl = new CameraControl("C:/Users/kindl/Downloads/asds.avi");
            }
            cameraControl.Run();
        }
    }
}