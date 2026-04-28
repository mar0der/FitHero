import EventKit
import SwiftUI

@MainActor
enum CalendarHelper {
    static let store = EKEventStore()

    static func addSessionToCalendar(
        title: String,
        startDate: Date,
        durationMinutes: Int,
        location: String?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let createEvent = {
            let event = EKEvent(eventStore: store)
            event.title = title
            event.startDate = startDate
            event.endDate = startDate.addingTimeInterval(TimeInterval(durationMinutes * 60))
            if let loc = location {
                event.location = loc
            }
            event.calendar = store.defaultCalendarForNewEvents

            do {
                try store.save(event, span: .thisEvent)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }

        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .fullAccess, .writeOnly:
            createEvent()
        case .notDetermined:
            store.requestFullAccessToEvents { granted, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else if granted {
                        createEvent()
                    } else {
                        completion(.failure(CalendarError.denied))
                    }
                }
            }
        case .denied, .restricted:
            completion(.failure(CalendarError.denied))
        @unknown default:
            completion(.failure(CalendarError.unknown))
        }
    }

    enum CalendarError: LocalizedError {
        case denied
        case unknown

        var errorDescription: String? {
            switch self {
            case .denied:
                return "Calendar access denied. Enable it in Settings > Privacy & Security > Calendars."
            case .unknown:
                return "Something went wrong. Please try again."
            }
        }
    }
}
