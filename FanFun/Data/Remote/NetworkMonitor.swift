import Network
import Foundation

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.fanfun.networkmonitor")
    
    private(set) var isConnected: Bool = true
    
    private init() {}
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
                let status = path.status == .satisfied ? "🟢 Online" : "🔴 Offline"
                print("NetworkMonitor: \(status)")
            }
        }
        monitor.start(queue: queue)
        isConnected = monitor.currentPath.status == .satisfied
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
