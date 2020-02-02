
namespace VideoHandler
{
    class Program
    {
        static void Main(string[] args)
        {
            var cameraControl = new CameraControl("C:/Users/kindl/Downloads/asds.avi");
            cameraControl.Run();
        }
    }
}