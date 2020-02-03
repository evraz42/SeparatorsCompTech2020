using DatabaseController.DataTypesInterfaces;
using System;
using System.Data.Entity.Infrastructure;
using System.Drawing;
using System.IO;
using System.Linq;

namespace DatabaseController
{
    public sealed class DatabaseSaver
    {
        private readonly Device _savedDevice;
        private readonly byte[] _picture;

        public DatabaseSaver(Device savedObject, byte[] picture)
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

            SaveFlagInfo();

            using var context = new DatabaseContext();
            context.Devices.Add(_savedDevice);

            
            context.SaveChanges();
            
          
        }

        private void SaveFlagInfo()
        {
            using var stream = new MemoryStream(_picture);
            var image = Image.FromStream(stream);

            //ImageProcessor.DrawRectangle(
            //    image,
            //    _savedDevice.FlagsPosition[0],
            //    _savedDevice.FlagsPosition[1],
            //    _savedDevice.FlagsPosition[2],
            //    _savedDevice.FlagsPosition[3]);

            foreach (var flag in _savedDevice.flags)
            {
                flag.Time = DateTimeOffset.Now;

                var savedPath = "C:/Users/kindl/Downloads/a/" 
                    + _savedDevice.name_device + "_"
                    + _savedDevice.number_device +"_"
                    +flag.TypeFlag +".jpg";

                flag.ImagePath = savedPath;
                flag.Time = DateTimeOffset.Now;
                flag.IdDevice = _savedDevice.id_device;
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

            if (lastDevice.Equals(_savedDevice))
            {
                return true;
            }
            return false;
        }
    }
}
