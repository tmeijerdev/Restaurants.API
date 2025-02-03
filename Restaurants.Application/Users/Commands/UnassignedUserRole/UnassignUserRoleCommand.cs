using System;
using MediatR;

namespace Restaurants.Application.Users.Commands.UnassignedUserRole;

public class UnassignUserRoleCommand : IRequest
{
    public string UserEmail { get; set; } = default!;
    public string RoleName { get; set; } = default!;
}
