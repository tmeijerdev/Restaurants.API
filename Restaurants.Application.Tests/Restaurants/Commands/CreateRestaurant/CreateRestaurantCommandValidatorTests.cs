using System;
using FluentValidation.TestHelper;
using Restaurants.Application.Restaurants.Commands.CreateRestaurant;

namespace Restaurants.Application.Tests.Restaurants.Commands.CreateRestaurant;

public class CreateRestaurantCommandValidatorTests
{
    [Fact]
    public void Validator_ForValidCommand_ShouldNotHaveValidationErrors()
    {
        // Arrange
        var command = new CreateRestaurantCommand
        {
            Name = "Test",
            Category = "Italian",
            ContactEmail = "test@test.com",
            PostalCode = "12-123"
        };
        
        var validator = new CreateRestaurantCommandValidator();

        // Act
        var result = validator.TestValidate(command);

        // Assert 
        result.ShouldNotHaveAnyValidationErrors();
    }

    [Fact]
    public void Validator_ForValidCommand_ShouldHaveValidationErrors()
    {
        // Arrange
        var command = new CreateRestaurantCommand
        {
            Name = "TE",
            Category = "Russian",
            ContactEmail = "@test.com",
            PostalCode = "12123"
        };
        
        var validator = new CreateRestaurantCommandValidator();

        // Act
        var result = validator.TestValidate(command);

        // Assert 
        result.ShouldHaveValidationErrorFor(c => c.Name);
        result.ShouldHaveValidationErrorFor(c => c.Category);
        result.ShouldHaveValidationErrorFor(c => c.ContactEmail);
        result.ShouldHaveValidationErrorFor(c => c.PostalCode);
    }

    [Theory]
    [InlineData("Italian")]
    [InlineData("Mexican")]
    [InlineData("Japanese")]
    [InlineData("American")]
    [InlineData("Indian")]
    public void Validator_ForValidCategory_ShouldNotHaveValidationErrorsForCategoryProperty(string category)
    {
        // Arrange
        var validator = new CreateRestaurantCommandValidator();
        var command = new CreateRestaurantCommand{ Category = category };

        // Act
        var result = validator.TestValidate(command);

        // Assert 
        result.ShouldNotHaveValidationErrorFor(c => c.Category);
    }

    [Theory]
    [InlineData("1020201")]
    [InlineData("102-20")]
    [InlineData("10 10")]
    [InlineData("10 200")]
    [InlineData("10-2 20")]
    public void Validator_ForInvalidPostalCode_ShouldHaveValidationErrorsForPostalCodeProperty(string postalCode)
    {
        // Arrange
        var validator = new CreateRestaurantCommandValidator();
        var command = new CreateRestaurantCommand{ PostalCode = postalCode };

        // Act
        var result = validator.TestValidate(command);

        // Assert 
        result.ShouldHaveValidationErrorFor(c => c.PostalCode);
    }
}
