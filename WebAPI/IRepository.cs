using WebAPI.Entities;
using WebAPI.Models;

namespace WebAPI
{
    public interface IRepository : IDisposable
    {
        Task<IList<Product>> GetAsync(string name);
        Task InsertAsync(ProductModelForInsert entry);
        Task UpdateAsync(ProductModelForUpdate entry);
        Task DeleteAsync(string id);
    }
}
