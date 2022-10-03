using Microsoft.EntityFrameworkCore;
using WebAPI.Entities;

namespace WebAPI
{
    public class TestDBContext : DbContext
    {
        public DbSet<Product> Products { get; set; }
        public DbSet<ProductVersion> ProductVersions { get; set; }


        public TestDBContext(DbContextOptions options)
            : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Product>(entity =>
            {
                entity.ToTable("Product");
                entity.HasKey(e => e.ID);
            });

            modelBuilder.Entity<ProductVersion>(entity =>
            {
                entity.ToTable("ProductVersion");
                entity.HasKey(e => e.ID);
                entity.HasOne(h => h.Product)
                    .WithMany(w => w.ProductVersions)
                    .HasForeignKey(f => f.ProductID);
            });
        }
    }
}
