namespace Volentry.Core.Exceptions;

public class SlotFullException(Guid slotId, Guid roleId)
    : Exception($"Role {roleId} in slot {slotId} is at full capacity.")
{
    public Guid SlotId { get; } = slotId;
    public Guid RoleId { get; } = roleId;
}
