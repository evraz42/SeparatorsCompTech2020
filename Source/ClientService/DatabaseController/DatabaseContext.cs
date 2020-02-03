using DatabaseController.DataTypesInterfaces;
using System.Data.Entity;

namespace DatabaseController
{
    public partial class DatabaseContext : DbContext
    {
        public DatabaseContext()
            : base("Host=localhost;Database=SeparatorsCompTech2020;Username=postgres;Password=1234")
        {
        }

        public virtual DbSet<Device> Devices { get; set; }
        public virtual DbSet<Flag> Flags { get; set; }
        public virtual DbSet<Log> Logs { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Device>()
                .HasMany(e => e.flags)
                .WithRequired(e => e.devices)
                .WillCascadeOnDelete(false);
        }
    }
}