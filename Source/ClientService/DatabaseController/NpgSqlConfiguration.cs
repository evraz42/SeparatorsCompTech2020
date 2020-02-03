using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Npgsql;
using System.Data.Entity;

namespace DatabaseController
{
    public class NpgSqlConfiguration : DbConfiguration
    {
        public NpgSqlConfiguration()
        {
            SetProviderFactory("Npgsql", NpgsqlFactory.Instance);
            SetProviderServices("Npgsql", NpgsqlServices.Instance);

            SetDefaultConnectionFactory(new NpgsqlConnectionFactory());
        }
    }
}
