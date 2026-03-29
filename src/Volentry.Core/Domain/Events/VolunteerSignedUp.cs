namespace Volentry.Core.Domain.Events;

public record VolunteerSignedUp : DomainEvent
{
    public override string EventType => nameof(VolunteerSignedUp);
    public Guid SignupId { get; init; }
    public Guid SlotId { get; init; }
    public Guid RoleId { get; init; }
    public string VolunteerName { get; init; } = string.Empty;
    public string VolunteerEmail { get; init; } = string.Empty;
    public string VolunteerPhone { get; init; } = string.Empty;
    public string? Team { get; init; }
}
