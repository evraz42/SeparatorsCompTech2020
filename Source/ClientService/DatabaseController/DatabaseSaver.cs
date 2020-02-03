using DatabaseController.DataTypesInterfaces;
using System;
using System.Drawing;
using System.IO;
using System.Linq;

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
            if(!_savedDevice.IsValid())
            {
                return;
            }
            if (EqualsWithLast())
            {
                return;
            }

            _savedDevice.id_device = new Guid();
            SavePicture();

            using var context = new DatabaseContext();
            context.Devices.Add(_savedDevice);
            context.SaveChanges();
        }

        

        private void SavePicture()
        {
            using var stream = new MemoryStream(_picture);
            var image = Image.FromStream(stream);

            ImageProcessor.DrawRectangle(
                image,
                _savedDevice.FlagsPosition[0],
                _savedDevice.FlagsPosition[1],
                _savedDevice.FlagsPosition[2],
                _savedDevice.FlagsPosition[3]);

            foreach (var flag in _savedDevice.flags)
            {
                var savedPath = "~/files/" + _savedDevice.id_device.ToString()+ ".jpg";
                flag.image_path = savedPath;
                flag.time = new System.DateTimeOffset();
                image.Save(savedPath);
            }
        }

        private bool EqualsWithLast()
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
