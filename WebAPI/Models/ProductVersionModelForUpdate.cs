namespace WebAPI.Models
{
    public class ProductVersionModelForUpdate : ProductVersionModelForInsert
    {
        public string ID { get; set; }
        public string ProductID { get; set; }
    }
}
