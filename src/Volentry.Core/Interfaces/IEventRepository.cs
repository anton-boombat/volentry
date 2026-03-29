using Volentry.Core.Domain.Models;

namespace Volentry.Core.Interfaces;

public interface IEventRepository
{
    Task<VolunteerEvent?> GetByIdAsync(string orgSlug, Guid eventId, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<VolunteerEvent>> GetUpcomingAsync(string orgSlug, CancellationToken cancellationToken = default);
    Task UpsertAsync(VolunteerEvent volunteerEvent, CancellationToken cancellationToken = default);
}
