import XCTest
@testable import FanFun
import Alamofire

class NetworkClientTests: XCTestCase {

    var sut: NetworkClient!
    var session: Session!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = Session(configuration: configuration)
        sut = NetworkClient(session: session)
    }

    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubResponse = nil
        super.tearDown()
    }

    struct DummyModel: Codable, Equatable {
        let id: Int
        let name: String
    }

    func test_request_whenSuccessful_returnsDecodedObject() {
        let expectation = XCTestExpectation(description: "Completion handler called")
        let json = """
        {
            "id": 1,
            "name": "Test"
        }
        """
        MockURLProtocol.stubResponseData = json.data(using: .utf8)
        MockURLProtocol.stubResponse = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        sut.request(url: "https://test.com", parameters: [:]) { (result: Result<DummyModel, Error>) in
            switch result {
            case .success(let model):
                XCTAssertEqual(model.id, 1)
                XCTAssertEqual(model.name, "Test")
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_request_whenNetworkError_returnsError() {
        let expectation = XCTestExpectation(description: "Completion handler called")
        let mockError = NSError(domain: "test", code: -1, userInfo: nil)
        MockURLProtocol.stubError = mockError

        sut.request(url: "https://test.com", parameters: [:]) { (result: Result<DummyModel, Error>) in
            switch result {
            case .success:
                XCTFail("Expected error but got success")
            case .failure(let error):
                let afError = error as? AFError
                XCTAssertNotNil(afError)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_request_whenDecodingFails_returnsDecodingError() {
        let expectation = XCTestExpectation(description: "Completion handler called")
        let json = """
        {
            "invalid_id": "1",
            "invalid_name": "Test"
        }
        """
        MockURLProtocol.stubResponseData = json.data(using: .utf8)
        MockURLProtocol.stubResponse = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        sut.request(url: "https://test.com", parameters: [:]) { (result: Result<DummyModel, Error>) in
            switch result {
            case .success:
                XCTFail("Expected decoding error but got success")
            case .failure(let error):
                let afError = error as? AFError
                XCTAssertTrue(afError?.isResponseSerializationError == true)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
