namespace Volentry.Core.Domain.Events;

public abstract record DomainEvent
{
    public Guid EventId { get; init; } = Guid.NewGuid();
    public DateTimeOffset OccurredAt { get; init; } = DateTimeOffset.UtcNow;
    public string OrgSlug { get; init; } = string.Empty;
    public abstract string EventType { get; }
}
