namespace Volentry.Core.Domain.Models;

public record VolunteerEvent
{
    public Guid EventId { get; init; } = Guid.NewGuid();
    public string OrgSlug { get; init; } = string.Empty;
    public string Name { get; init; } = string.Empty;
    public DateTimeOffset Date { get; init; }
    public IReadOnlyList<EventSlot> Slots { get; init; } = [];
    public DateTimeOffset CreatedAt { get; init; } = DateTimeOffset.UtcNow;
}
