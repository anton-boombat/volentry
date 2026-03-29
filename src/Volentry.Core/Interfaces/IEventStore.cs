using Volentry.Core.Domain.Events;

namespace Volentry.Core.Interfaces;

public interface IEventStore
{
    Task AppendAsync(DomainEvent domainEvent, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<DomainEvent>> GetEventsAsync(string orgSlug, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<DomainEvent>> GetEventsForAggregateAsync(string orgSlug, Guid aggregateId, CancellationToken cancellationToken = default);
}
