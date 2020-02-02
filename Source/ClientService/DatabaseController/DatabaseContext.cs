using DatabaseController.DataTypesInterfaces;
using System.Data.Entity;

namespace DatabaseController
{
    public partial class DatabaseContext : DbContext
    {
        public DatabaseContext()
            : base("name=DatabaseModel")
        {
        }

        public virtual DbSet<IDevice> Devices { get; set; }
        public virtual DbSet<IFlag> Flags { get; set; }
        public virtual DbSet<ILog> Logs { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Device>()
                .HasMany(e => e.flags)
                .WithRequired(e => e.devices)
                .WillCascadeOnDelete(false);
        }
    }
}
