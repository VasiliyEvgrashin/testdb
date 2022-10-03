namespace WebAPI.Models
{
    public class ProductVersionModelForInsert
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime CreatingDate { get; set; }
        public decimal Width { get; set; }
        public decimal Height { get; set; }
        public decimal Length { get; set; }
    }
}
