using System.Drawing;
using System.IO;
using System.Linq;
using DatabaseController.DataTypesInterfaces;

namespace DatabaseController
{
    public sealed class DatabaseSaver
    {
        private readonly IDevice _savedDevice;
        private readonly byte[] _picture;

        public DatabaseSaver(IDevice savedObject, byte[] picture)
        {
            _savedDevice = savedObject;
            _picture = picture;
        }

        public void Save()
        {
            SavePicture();
            if (!CompareWithLast())
            {
                return;
            }

            SavePicture();

            using var context = new DatabaseContext();
            context.Devices.Add(_savedDevice);
            context.SaveChanges();
        }

        private void DrawRectangle(Image image)
        {
            using var g = Graphics.FromImage(image);
            g.DrawRectangle(new Pen(Color.Red, 3),
                new Rectangle(
                    _savedDevice.FlagsPosition[0],
                    _savedDevice.FlagsPosition[1],
                    _savedDevice.FlagsPosition[2],
                    _savedDevice.FlagsPosition[3]));
        }

        private void SavePicture()
        {

           

            //DrawRectangle(image);

            //foreach(var flag in _savedDevice.flags)
            {
                var savedPath = "C:/Users/kindl/Downloads/rrt.jpg";
                //flag.image_path = savedPath;
                //File.WriteAllBytes(savedPath, GetOneDimensionalArray(_picture));


                //image.Save(savedPath);
            }
        }




        private bool CompareWithLast()
        {
            using var context = new DatabaseContext();
            var lastDevice = context.Devices.Last();
            if (lastDevice.Equals(_savedDevice))
            {
                return true;
            }

            return false;
        }
    }
}
