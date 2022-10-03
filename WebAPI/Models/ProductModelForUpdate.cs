namespace WebAPI.Models
{
    public class ProductModelForUpdate : ProductModelFor
    {
        public string ID { get; set; }
        public ICollection<ProductVersionModelForUpdate> ProductVersions { get; set; }
    }
}
