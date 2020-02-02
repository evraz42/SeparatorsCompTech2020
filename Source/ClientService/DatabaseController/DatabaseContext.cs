namespace DatabaseController
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class DatabaseContext : DbContext
    {
        public DatabaseContext()
            : base("name=DatabaseModel")
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
