using JetBrains.Annotations;

namespace DatabaseController
{
    public sealed class DatabaseController
    {
        private readonly object _savedObject;

        public DatabaseController(object savedObject)
        {
            _savedObject = savedObject;
        }

        public void Save()
        {
           
            CompareWithLast();
        }

        private void CompareWithLast()
        {
            using var context = new DatabaseContext();

          
            
        }
    }
}
