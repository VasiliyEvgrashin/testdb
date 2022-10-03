namespace WebAPI.Entities
{
    public class Product : BaseEntry
    {
        public ICollection<ProductVersion> ProductVersions { get; set; }

        public Product()
        {
            ProductVersions = new List<ProductVersion>();
        }
    }
}
