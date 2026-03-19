using GirafAPI.Entities.Activities;
using Microsoft.EntityFrameworkCore;

namespace GirafAPI.Data
{
    public class GirafDbContext : DbContext
    {
        public GirafDbContext(DbContextOptions<GirafDbContext> options) : base(options)
        {
        }

        public DbSet<Activity> Activities { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Activity>(entity =>
            {
                entity.HasIndex(e => e.CitizenId);
                entity.HasIndex(e => e.GradeId);
                entity.HasIndex(e => e.PictogramId);
            });
        }
    }
}
