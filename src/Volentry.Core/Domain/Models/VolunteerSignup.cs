namespace Volentry.Core.Domain.Models;

public record VolunteerSignup
{
    public Guid SignupId { get; init; } = Guid.NewGuid();
    public string OrgSlug { get; init; } = string.Empty;
    public Guid SlotId { get; init; }
    public Guid RoleId { get; init; }
    public string VolunteerName { get; init; } = string.Empty;
    public string VolunteerEmail { get; init; } = string.Empty;
    public string VolunteerPhone { get; init; } = string.Empty;
    public string? Team { get; init; }
    public DateTimeOffset SignedUpAt { get; init; } = DateTimeOffset.UtcNow;
    public bool IsCancelled { get; init; }
    public DateTimeOffset? CancelledAt { get; init; }
}
