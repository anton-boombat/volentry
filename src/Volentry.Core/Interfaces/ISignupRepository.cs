using Volentry.Core.Domain.Models;

namespace Volentry.Core.Interfaces;

public interface ISignupRepository
{
    Task<VolunteerSignup?> GetByIdAsync(string orgSlug, Guid signupId, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<VolunteerSignup>> GetByEmailAsync(string orgSlug, string email, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<VolunteerSignup>> GetBySlotRoleAsync(string orgSlug, Guid slotId, Guid roleId, CancellationToken cancellationToken = default);
    Task UpsertAsync(VolunteerSignup signup, CancellationToken cancellationToken = default);
    Task<int> CountActiveAsync(string orgSlug, Guid slotId, Guid roleId, CancellationToken cancellationToken = default);
}
