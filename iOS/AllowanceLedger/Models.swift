import Foundation

struct LedgerEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var childName: String
    var label: String
    var amount: Double
    var date: Date
    var isCredit: Bool

    init(id: UUID = UUID(), childName: String = "", label: String = "", amount: Double = 0, date: Date = Date(), isCredit: Bool = false) {
        self.id = id
        self.childName = childName
        self.label = label
        self.amount = amount
        self.date = date
        self.isCredit = isCredit
    }
}
