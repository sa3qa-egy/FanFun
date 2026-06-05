import Foundation
@testable import FanFun

class MockNetworkMonitor: NetworkMonitorProtocol {

    var stubbedIsConnected: Bool

    init(isConnected: Bool = true) {
        self.stubbedIsConnected = isConnected
    }

    var isConnected: Bool {
        return stubbedIsConnected
    }
}
