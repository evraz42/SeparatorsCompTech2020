using DatabaseControllerCore.DatabaseTypes;
using JetBrains.Annotations;
using Microsoft.EntityFrameworkCore;

namespace DatabaseControllerCore
{
    public class DatabaseContext : DbContext
    {
        public DatabaseContext()
        {
        }

        public DatabaseContext([NotNull] DbContextOptions<DatabaseContext> options)
            : base(options)
        {
        }

        [NotNull][ItemNotNull] public virtual DbSet<Device> Devices { get; set; }
        [NotNull] [ItemNotNull] public virtual DbSet<Flag> Flags { get; set; }
        [NotNull] [ItemNotNull] public virtual DbSet<Logs> Logs { get; set; }

        protected override void OnConfiguring([NotNull]DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseNpgsql("Host=localhost;Database=SeparatorsCompTech2020;Username=postgres;Password=1234");
            }
        }

        protected override void OnModelCreating([NotNull]ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Device>(entity =>
            {
                entity.HasKey(e => e.IdDevice)
                    .HasName("devices_pk");

                entity.ToTable("devices");

                entity.Property(e => e.IdDevice)
                    .HasColumnName("id_device")
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<Flag>(entity =>
            {
                entity.ToTable("flags");

                entity.HasOne(d => d.IdDeviceNavigation)
                    .WithMany(p => p.Flags)
                    .HasForeignKey(d => d.IdDevice)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("flags_devices_id_device_fk");
            });

            modelBuilder.Entity<Logs>(entity =>
            {
                entity.ToTable("logs");

                entity.HasIndex(e => e.Id)
                    .HasName("logs_id_uindex")
                    .IsUnique();

                entity.HasIndex(e => e.Time)
                    .HasName("logs_time_index");

            });
        }
    }
}
