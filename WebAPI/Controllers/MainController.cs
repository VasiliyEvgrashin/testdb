using Microsoft.AspNetCore.Mvc;
using WebAPI.Entities;
using WebAPI.Models;

namespace WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MainController : ControllerBase 
    {
        IRepository repository;
        public MainController(IRepository repository)
        {
            this.repository = repository;
        }

        [HttpGet("get/{name}")]
        public async Task<IList<Product>> Get(string name)
        {
            return await repository.GetAsync(name);
        }
                [HttpPost("add")]
        public async Task Insert([FromBody]ProductModelForInsert product)
        {
            await repository.InsertAsync(product);
        }

        [HttpPut("update")]
        public async Task Update([FromBody]ProductModelForUpdate product)
        {
            await repository.UpdateAsync(product);
        }

        [HttpDelete("delete")]
        public async Task Delete(string id)
        {
            await repository.DeleteAsync(id);
        }
    }
}