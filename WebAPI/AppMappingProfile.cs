using AutoMapper;
using WebAPI.Entities;
using WebAPI.Models;

namespace WebAPI
{
    public class AppMappingProfile : Profile
    {
        public AppMappingProfile()
        {
            CreateMap<ProductModelForInsert, Product>()
                .ForMember(dest => dest.ID, opt => opt.MapFrom(src => Guid.NewGuid().ToString()));
            CreateMap<ProductModelForUpdate, Product>();
            CreateMap<ProductVersionModelForInsert, ProductVersion>()
                .ForMember(dest => dest.ID, opt => opt.MapFrom(src => Guid.NewGuid().ToString()));
            CreateMap<ProductVersionModelForUpdate, ProductVersion>()
                .ForMember(dest => dest.ID, opt => opt.MapFrom(src => string.IsNullOrEmpty(src.ID) ? Guid.NewGuid().ToString() : src.ID));
        }
    }
}
