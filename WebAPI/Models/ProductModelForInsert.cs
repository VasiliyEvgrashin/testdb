namespace WebAPI.Models
{
    public class ProductModelForInsert : ProductModelFor
    {
        public ICollection<ProductVersionModelForInsert> ProductVersions { get; set; }
    }
}
