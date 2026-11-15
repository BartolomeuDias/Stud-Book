using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using StudBook.Domain;
 
namespace Infrastructure.Persistence.Configurations;
 
public class LocationConfiguration : IEntityTypeConfiguration<Location>
{
    public void Configure(EntityTypeBuilder<Location> b)
    {
        b.HasKey(x => x.Id);
 
        b.Property(x => x.Name).IsRequired().HasMaxLength(100);
        b.HasIndex(x => x.Name).IsUnique();
 
        b.Property(x => x.Type).HasConversion<string>().HasMaxLength(32);
    }
}