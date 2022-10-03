using AutoMapper;
using Microsoft.EntityFrameworkCore;
using WebAPI.Entities;
using WebAPI.Models;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace WebAPI
{
    public class Repository : IRepository
    {
        TestDBContext context;
        IMapper mapper;
        public Repository(TestDBContext context, IMapper mapper)
        {
            this.context = context;
            this.mapper = mapper;
        }

        public async Task<IList<Product>> GetAsync(string name)
        {
            var result = await context
                .Products
                .Include(i => i.ProductVersions)
                .Where(w => w.Name.Contains(name))
                .ToListAsync();
            return result;
        }

        public async Task InsertAsync(ProductModelForInsert entry)
        {
            Product? product = await context.Products.FirstOrDefaultAsync(f => f.Name == entry.Name);
            if (product != null)
                return;
            await context.Products.AddAsync(mapper.Map<Product>(entry));
            await context.SaveChangesAsync();
        }

        public async Task DeleteAsync(string id)
        {
            Product? product = await context.Products.FirstOrDefaultAsync(f => f.ID == id);
            if (product == null)
                return;
            context.Products.Remove(product);
            await context.SaveChangesAsync();
        }
        
        public async Task UpdateAsync(ProductModelForUpdate entry)
        {
            await DeleteAsync(entry.ID);
            Product product = mapper.Map<Product>(entry);
            context.Products.Add(product);
            await context.SaveChangesAsync();
        }

        bool disposed = false;
        protected virtual void Dispose(bool disposing)
        {
            if (!disposed)
            {
                if (disposing)
                {
                    context.Dispose();
                }
            }
            disposed = true;
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
