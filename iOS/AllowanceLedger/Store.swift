import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [LedgerEntry] = []
    @Published var isPro: Bool = false

    static let freeLimit = 200

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("allowanceledger_items.json")
        load()
    }

    var isAtFreeLimit: Bool {
        !isPro && items.count >= Store.freeLimit
    }

    func add(_ item: LedgerEntry) -> Bool {
        guard !isAtFreeLimit else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: LedgerEntry) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: LedgerEntry) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([LedgerEntry].self, from: data) else {
            items = [
        LedgerEntry(childName: "Sample Childname 1", label: "Sample Label 1", amount: 5.0, date: Calendar.current.date(byAdding: .day, value: -0, to: Date()) ?? Date(), isCredit: false),
        LedgerEntry(childName: "Sample Childname 2", label: "Sample Label 2", amount: 10.0, date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), isCredit: true),
        LedgerEntry(childName: "Sample Childname 3", label: "Sample Label 3", amount: 15.0, date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), isCredit: false)
            ]
            save()
            return
        }
        items = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
