using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using StudBook.Domain;
 
namespace Infrastructure.Persistence.Configurations;
 
public class HorsePlacementConfiguration : IEntityTypeConfiguration<HorsePlacement>
{
    public void Configure(EntityTypeBuilder<HorsePlacement> b)
    {
        b.HasKey(x => x.Id);
 
        b.Property(x => x.Origin).HasMaxLength(200);
        b.Property(x => x.Notes).HasMaxLength(2000);
 
        b.HasOne(x => x.Horse)
            .WithMany(h => h.Placements)
            .HasForeignKey(x => x.HorseId)
            .OnDelete(DeleteBehavior.Restrict);
 
        b.HasOne(x => x.Location)
            .WithMany(l => l.Placements)
            .HasForeignKey(x => x.LocationId)
            .OnDelete(DeleteBehavior.Restrict);
 
        // Основные выборки: история лошади и «кто был в этом месте в период».
        b.HasIndex(x => new { x.HorseId, x.ArrivedOn });
        b.HasIndex(x => new { x.LocationId, x.ArrivedOn });
 
        b.ToTable(t => t.HasCheckConstraint(
            "CK_HorsePlacements_Dates", "\"LeftOn\" IS NULL OR \"LeftOn\" >= \"ArrivedOn\""));
    }
}