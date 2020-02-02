using System.IO;
using System.Linq;

namespace DatabaseController
{
    public sealed class DatabaseSaver
    {
        private readonly Device _savedDevice;
        private readonly byte[,] _picture;

        public DatabaseSaver(Device savedObject, byte[,] picture)
        {
            _savedDevice = savedObject;
            _picture = picture;
        }

        public void Save()
        {
            if(!CompareWithLast())
            {
                return;
            }

            SavePicture();

            using var context = new DatabaseContext();
            context.Devices.Add(_savedDevice);
            context.SaveChanges();
        }

        private void SavePicture()
        {
            foreach(var flag in _savedDevice.flags)
            {
                var savedPath = "";
                flag.image_path = savedPath;
                File.WriteAllBytes(savedPath, GetOneDimensionalArray<byte>(_picture));
            }
        }

        private static T[] GetOneDimensionalArray<T>(T[,] array)
        {
            var resultArray = new T[array.GetLongLength(0) * array.GetLongLength(1)];
            for (var i = 0; i < array.GetLongLength(0); i++)
            {
                for (var j = 0; j < array.GetLongLength(1); j++)
                {
                    resultArray[i * array.GetLongLength(1) + j] = array[i, j];
                }
            }
            return resultArray;
        }

        private bool CompareWithLast()
        {
            using var context = new DatabaseContext();
            var lastDevice = context.Devices.Last();
            if(lastDevice.Equals(_savedDevice))
            {
                return true;
            }

            return false;
        }
    }
}
