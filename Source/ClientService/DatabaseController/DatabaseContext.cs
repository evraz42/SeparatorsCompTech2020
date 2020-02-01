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

        public virtual DbSet<Devices> Devices { get; set; }
        public virtual DbSet<Flags> Flags { get; set; }
        public virtual DbSet<Logs> Logs { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Devices>()
                .HasMany(e => e.flags)
                .WithRequired(e => e.devices)
                .WillCascadeOnDelete(false);
        }
    }
}
