namespace Volentry.Core.Exceptions;

public class CancellationWindowClosedException(DateTimeOffset eventDate)
    : Exception($"Cancellations are not permitted within 2 days of the event (event date: {eventDate:yyyy-MM-dd}).")
{
    public DateTimeOffset EventDate { get; } = eventDate;
}
