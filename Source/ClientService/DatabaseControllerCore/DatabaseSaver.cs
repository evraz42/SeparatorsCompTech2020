using JetBrains.Annotations;
using System;
using System.Drawing;
using System.IO;
using System.Linq;
using Guard;

namespace DatabaseControllerCore
{
    public sealed class DatabaseSaver
    {
        [NotNull] private readonly Device _savedDevice;
        [NotNull] private readonly byte[] _imageBytes;

        public DatabaseSaver([NotNull] Device savedObject, [NotNull] byte[] imageBytes)
        {
            _savedDevice = savedObject;
            _imageBytes = imageBytes;
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

            SaveFlagInfo();

            using var context = new DatabaseContext();
            context.Devices.Add(_savedDevice);
            context.SaveChanges();
        }

        private void SaveFlagInfo()
        {
            using var stream = new MemoryStream(_imageBytes);
            var image = Image.FromStream(stream);

            if (_savedDevice.FlagsPosition.Length != 4)
            {
                return;
            }
            ImageProcessor.DrawRectangle(
                image,
                _savedDevice.FlagsPosition[0],
                _savedDevice.FlagsPosition[1],
                _savedDevice.FlagsPosition[2],
                _savedDevice.FlagsPosition[3]);

            foreach (var flag in _savedDevice.Flags)
            {
                flag.Time = DateTime.Now;
                flag.IdDevice = _savedDevice.IdDevice;

                var savedPath = "C:/Users/User/Downloads/a/" 
                    + _savedDevice.NameDevice
                    + _savedDevice.NumberDevice +"_"
                    + flag.TypeFlag + "_"
                    + flag.Time.ToShortDateString() + "_"
                    + flag.Time.Hour + "."
                    + flag.Time.Minute + "."
                    + flag.Time.Second + ".jpg";

                flag.ImagePath = savedPath;
                image.Save(savedPath);
            }
        }

        private bool EqualsWithLast()
        {
            using var context = new DatabaseContext();
            if(context.Devices.ToList().Count == 0)
            {
                return false;
            }

            var lastDevice = context.Devices.ToList().Last();
            if(lastDevice == null)
            {
                return false;
            }

            return lastDevice.Equals(_savedDevice);
        }
    }
}
