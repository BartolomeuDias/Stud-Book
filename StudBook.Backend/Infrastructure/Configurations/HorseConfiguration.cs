using StudBook.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Configurations;
public class HorseConfiguration : IEntityTypeConfiguration<Horse>
{
    public void Configure(EntityTypeBuilder<Horse> b)
    {
        b.HasKey(x => x.Id);
 
        b.Property(x => x.Name).IsRequired().HasMaxLength(200);
 
        // Уникален, если указан (в PostgreSQL несколько NULL в уникальном индексе допустимы).
        b.Property(x => x.RegistrationNumber).HasMaxLength(50);
        b.HasIndex(x => x.RegistrationNumber).IsUnique();
 
        b.Property(x => x.Category).HasConversion<string>().HasMaxLength(32);
        b.Property(x => x.Sex).HasConversion<string>().HasMaxLength(32);
        b.Property(x => x.Breed).IsRequired().HasMaxLength(100);
        b.Property(x => x.Color).IsRequired().HasMaxLength(50);
        b.Property(x => x.Notes).HasMaxLength(2000);
 
        b.HasIndex(x => x.Category);
        b.HasIndex(x => x.Name);
 
        b.HasOne(x => x.OwnerClient)
            .WithMany(c => c.Horses)
            .HasForeignKey(x => x.OwnerClientId)
            .OnDelete(DeleteBehavior.Restrict);
 
        // Родословная: самоссылка. Два поколения получаются обходом SireId/DamId.
        b.HasOne(x => x.Sire)
            .WithMany(x => x.SiredOffspring)
            .HasForeignKey(x => x.SireId)
            .OnDelete(DeleteBehavior.Restrict);
 
        b.HasOne(x => x.Dam)
            .WithMany(x => x.DamOffspring)
            .HasForeignKey(x => x.DamId)
            .OnDelete(DeleteBehavior.Restrict);
 
        b.ToTable(t =>
        {
            t.HasCheckConstraint("CK_Horses_SireNotSelf", "\"SireId\" IS NULL OR \"SireId\" <> \"Id\"");
            t.HasCheckConstraint("CK_Horses_DamNotSelf", "\"DamId\" IS NULL OR \"DamId\" <> \"Id\"");
        });
    }
}