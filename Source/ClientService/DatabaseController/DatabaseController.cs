using JetBrains.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseController
{
    public sealed class DatabaseController
    {
        [NotNull] private readonly object _savedObject;

        public DatabaseController([NotNull] object savedObject)
        {
            _savedObject = savedObject;
        }

        public void Save()
        {
           
            CompareWithLast();
        }

        private void CompareWithLast()
        {
            using (var context = new DatabaseContext())
            {
                var separators = context.Separators;
                foreach (var separator in separators)
                {
                    Console.WriteLine("{0}.{1} - {2}", u.Id, u.Name, u.Age);
                }
            }
        }
    }
}
