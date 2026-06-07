import Network
import Foundation

// MARK: - NetworkMonitor
class NetworkMonitor: NetworkMonitorProtocol {
    
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.fanfun.networkmonitor")
    
    private(set) var isConnected: Bool = true
    
    init() {}
    
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
