namespace Volentry.Core.Domain.Models;

public record EventSlotRole
{
    public Guid RoleId { get; init; } = Guid.NewGuid();
    public string Name { get; init; } = string.Empty;
    public int Capacity { get; init; }
}
