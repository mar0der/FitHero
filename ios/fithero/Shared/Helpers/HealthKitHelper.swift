import HealthKit

@MainActor
class HealthKitHelper {
    static let shared = HealthKitHelper()
    private let store = HKHealthStore()

    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuth() async -> Bool {
        guard isAvailable else { return false }
        guard let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass) else { return false }
        do {
            try await store.requestAuthorization(toShare: [], read: [weightType])
            return true
        } catch {
            return false
        }
    }

    func fetchMostRecentWeight() async -> Double? {
        guard isAvailable else { return nil }
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return nil }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let predicate = HKQuery.predicateForSamples(withStart: nil, end: Date(), options: .strictEndDate)

        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: weightType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                guard let sample = samples?.first as? HKQuantitySample else {
                    continuation.resume(returning: nil)
                    return
                }
                let weightInKg = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
                continuation.resume(returning: weightInKg)
            }
            store.execute(query)
        }
    }
}
