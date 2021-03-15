import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var tab: String {
        didSet {
            UserDefaults.standard.set(tab, forKey: "tab")
        }
    }
    
    public var tabs = ["Items", "Identity"]
    
    init() {
        self.tab = UserDefaults.standard.object(forKey: "tab") as? String ?? "Items"
    }
}
