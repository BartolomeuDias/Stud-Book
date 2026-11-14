using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using StudBook.Domain;
 
namespace Infrastructure.Persistence.Configurations;
 
public class ClientConfiguration : IEntityTypeConfiguration<Client>
{
    public void Configure(EntityTypeBuilder<Client> b)
    {
        b.HasKey(x => x.Id);
 
        b.Property(x => x.Name).IsRequired().HasMaxLength(200);
        b.Property(x => x.Type).HasConversion<string>().HasMaxLength(32);
        b.Property(x => x.StateCode).IsRequired().HasMaxLength(8);
        b.Property(x => x.ContactInfo).HasMaxLength(500);
        b.Property(x => x.Notes).HasMaxLength(2000);
 
        // Клиент связан с учётной записью не обязательно (UserId — nullable, уникален).
        b.HasOne(x => x.User)
            .WithOne(u => u.Client)
            .HasForeignKey<Client>(x => x.UserId)
            .OnDelete(DeleteBehavior.SetNull);
    }
}