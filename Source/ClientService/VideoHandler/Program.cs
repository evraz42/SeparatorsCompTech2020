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
            var filePath = args[0];
            if (!File.Exists(filePath))
            {
                Console.WriteLine("Error: Path is invalid!");
            }

            CameraControl cameraControl;
            if (args.Length == 2 && int.TryParse(args[1], out var secDelay))
            {
                cameraControl = new CameraControl(filePath, secDelay);
            }
            else
            {
                cameraControl = new CameraControl(filePath);
            }
            cameraControl.Run();
        }
    }
}