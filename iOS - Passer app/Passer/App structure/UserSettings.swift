import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var tab: String {
        didSet {
            UserDefaults.standard.set(tab, forKey: "tab")
        }
    }
    
    @Published var useBiometry: Bool {
        didSet {
            UserDefaults.standard.set(useBiometry, forKey: "biometry")
        }
    }
    
    public var tabs = ["Items", "Identity"]
    
    init() {
        self.tab = UserDefaults.standard.object(forKey: "tab") as? String ?? "Items"
        self.useBiometry = UserDefaults.standard.object(forKey: "biometry") as? Bool ?? false
    }
}
