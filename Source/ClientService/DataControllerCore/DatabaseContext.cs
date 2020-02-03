using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace DataControllerCore
{
    public partial class DatabaseContext : DbContext
    {
        public DatabaseContext()
        {
        }

        public DatabaseContext(DbContextOptions<DatabaseContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Device> Devices { get; set; }
        public virtual DbSet<Flag> Flags { get; set; }
        public virtual DbSet<Logs> Logs { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseNpgsql("Host=localhost;Database=SeparatorsCompTech2020;Username=postgres;Password=1234");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Device>(entity =>
            {
                entity.HasKey(e => e.IdDevice)
                    .HasName("devices_pk");

                entity.ToTable("devices");

                entity.Property(e => e.IdDevice)
                    .HasColumnName("id_device")
                    .ValueGeneratedNever();

                entity.Property(e => e.NameDevice)
                    .IsRequired()
                    .HasColumnName("name_device");

                entity.Property(e => e.NumberDevice).HasColumnName("number_device");
            });

            modelBuilder.Entity<Flag>(entity =>
            {
                entity.ToTable("flags");

                entity.HasIndex(e => e.Id)
                    .HasName("flags_id_uindex")
                    .IsUnique();

                entity.HasIndex(e => e.Positions)
                    .HasName("flags_positions_index");

                entity.HasIndex(e => e.Time)
                    .HasName("flags_time_index");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.CurrentPosition).HasColumnName("current_position");

                entity.Property(e => e.CurrentProbability).HasColumnName("current_probability");

                entity.Property(e => e.IdDevice).HasColumnName("id_device");

                entity.Property(e => e.ImagePath)
                    .IsRequired()
                    .HasColumnName("image_path");

                entity.Property(e => e.Positions)
                    .IsRequired()
                    .HasColumnName("positions");

                entity.Property(e => e.Time)
                    .HasColumnName("time")
                    .HasColumnType("timestamp with time zone");

                entity.Property(e => e.TypeFlag).HasColumnName("type_flag");

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

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Level)
                    .IsRequired()
                    .HasColumnName("level");

                entity.Property(e => e.Message)
                    .IsRequired()
                    .HasColumnName("message");

                entity.Property(e => e.Time)
                    .HasColumnName("time")
                    .HasColumnType("timestamp with time zone");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
