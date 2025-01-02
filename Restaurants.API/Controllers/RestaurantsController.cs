using Microsoft.AspNetCore.Mvc;
using Restaurants.Application.Restaurants;
using Restaurants.Application.Restaurants.DTOs;

namespace Restaurants.API.Controllers
{
    // ApiController attribute automatically checks if the request body has the obligated values that can't be null
    [Route("api/[controller]")]
    [ApiController]
    public class RestaurantsController(IRestaurantsService restaurantsService) : ControllerBase
    {
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var restaurants = await restaurantsService.GetAllRestaurants();
            return Ok(restaurants);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute] int id)
        {
            var restaurant = await restaurantsService.GetById(id);
            if (restaurant is null)
                return NotFound();

            return Ok(restaurant);
        }

        // [FromBody] attribute is not necessary if [ApiController] attirbute is added
        [HttpPost]
        public async Task<IActionResult> CreateRestaurant(CreateRestaurantDto createRestaurantDto)
        {
            int id = await restaurantsService.Create(createRestaurantDto);

            // return the newly created record url
            return CreatedAtAction(nameof(GetById), new { id }, null);
        }
    }
}
