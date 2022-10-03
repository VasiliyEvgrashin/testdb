namespace WebAPI.Entities
{
    public class ProductVersion : BaseEntry
    {
        public DateTime CreatingDate { get; set; }
        public decimal Width { get; set; }
        public decimal Height { get; set; }
        public decimal Length { get; set; }
        public string ProductID { get; set; }
        public Product Product { get; set; }
    }
}
