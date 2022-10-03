namespace WebAPI.Entities
{
    public abstract class BaseEntry
    {
        public string ID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }

        protected BaseEntry()
        {
        }
    }
}
