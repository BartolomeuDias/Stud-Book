using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using StudBook.Domain;
 
namespace Infrastructure.Persistence.Configurations;
 
public class CompatibilityRuleConfiguration : IEntityTypeConfiguration<CompatibilityRule>
{
    public void Configure(EntityTypeBuilder<CompatibilityRule> b)
    {
        b.HasKey(x => x.Id);
 
        b.Property(x => x.Code).IsRequired().HasMaxLength(64);
        b.HasIndex(x => x.Code).IsUnique();
 
        b.Property(x => x.Description).IsRequired().HasMaxLength(1000);
        b.Property(x => x.DenialMessage).IsRequired().HasMaxLength(500);
        b.Property(x => x.ThresholdUnit).HasMaxLength(64);
        b.Property(x => x.Source).HasConversion<string>().HasMaxLength(32);
    }
}