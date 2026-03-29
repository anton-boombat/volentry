namespace Volentry.Core.Domain.Events;

public record SignupCancelled : DomainEvent
{
    public override string EventType => nameof(SignupCancelled);
    public Guid SignupId { get; init; }
    public Guid SlotId { get; init; }
    public Guid RoleId { get; init; }
    public string CancelledBy { get; init; } = string.Empty; // "volunteer" | "admin"
}
