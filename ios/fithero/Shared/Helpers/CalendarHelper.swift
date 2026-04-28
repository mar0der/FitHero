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
        completion: @escaping (Result<Void, CalendarError>) -> Void
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
                completion(.failure(.saveFailed(error.localizedDescription)))
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
                        completion(.failure(.saveFailed(error.localizedDescription)))
                    } else if granted {
                        createEvent()
                    } else {
                        completion(.failure(.denied))
                    }
                }
            }
        case .denied, .restricted:
            completion(.failure(.denied))
        @unknown default:
            completion(.failure(.unknown))
        }
    }

    static func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    enum CalendarError: LocalizedError {
        case denied
        case unknown
        case saveFailed(String)

        var errorDescription: String? {
            switch self {
            case .denied:
                return "Calendar access is required to add sessions."
            case .unknown:
                return "Something went wrong. Please try again."
            case .saveFailed(let msg):
                return msg
            }
        }
    }
}
