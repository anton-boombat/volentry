namespace Volentry.Core.Domain.Models;

public record EventSlot
{
    public Guid SlotId { get; init; } = Guid.NewGuid();
    public DateTimeOffset StartTime { get; init; }
    public DateTimeOffset EndTime { get; init; }
    public IReadOnlyList<EventSlotRole> Roles { get; init; } = [];
}
