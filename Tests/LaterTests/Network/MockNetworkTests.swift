import XCTest
@testable import Later

final class MockNetworkTests: XCTestCase {
    var url: URL {
        get throws {
            try XCTUnwrap(URL(string: Self.self.description()))
        }
    }

    func testRequest() async throws 	{
        let expectedString = "Hello, world!"
        let network = MockNetwork(
            responseData: expectedString.data(using: .utf8),
            response: nil
        )

        let dataResponse = try await network.request(for: try url, method: .GET, headerFields: [:], body: nil)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }

    func testAPI() async throws {
        enum ExampleEndpoint: Endpoint {
            static var url: URL { URL(string: "example")! }

            case hello

            var method: HTTPRequestMethod {
                switch self {
                case .hello:    return .GET
                }
            }

            var path: String {
                switch self {
                case .hello:    return "hello"
                }
            }

            var headers: [String: String] {
                switch self {
                case .hello:
                    return [
                        "id": "hello"
                    ]
                }
            }

            var body: Data? {
                switch self {
                case .hello:    return "hello".data(using: .utf8)
                }
            }
        }

        let api = MockAPI<ExampleEndpoint>()
        let expectedString = "hello"

        let dataResponse = try await api.request(.hello)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }

    func testGet() async throws {
        let expectedString = "Hello, GET"
        let network = MockNetwork(responseData: expectedString.data(using: .utf8), response: nil)

        let dataResponse = try await network.get(url: url)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }

    func testHead() async throws {
        let expectedString = "Hello, HEAD"
        let network = MockNetwork(responseData: expectedString.data(using: .utf8), response: nil)

        let dataResponse = try await network.head(url: url)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }

    func testPost() async throws {
        let expectedString = "Hello, POST"
        let network = MockNetwork(responseData: expectedString.data(using: .utf8), response: nil)

        let dataResponse = try await network.post(url: url, body: nil)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }

    func testPut() async throws {
        let expectedString = "Hello, PUT"
        let network = MockNetwork(responseData: expectedString.data(using: .utf8), response: nil)

        let dataResponse = try await network.put(url: url, body: nil)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }

    func testDelete() async throws {
        let expectedString = "Hello, DELETE"
        let network = MockNetwork(responseData: expectedString.data(using: .utf8), response: nil)

        let dataResponse = try await network.delete(url: url, body: nil)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }

    func testConnect() async throws {
        let expectedString = "Hello, CONNECT"
        let network = MockNetwork(responseData: expectedString.data(using: .utf8), response: nil)

        let dataResponse = try await network.connect(url: url)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }

    func testOptions() async throws {
        let expectedString = "Hello, OPTIONS"
        let network = MockNetwork(responseData: expectedString.data(using: .utf8), response: nil)

        let dataResponse = try await network.options(url: url)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }

    func testTrace() async throws {
        let expectedString = "Hello, TRACE"
        let network = MockNetwork(responseData: expectedString.data(using: .utf8), response: nil)

        let dataResponse = try await network.trace(url: url)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }

    func testPatch() async throws {
        let expectedString = "Hello, PATCH"
        let network = MockNetwork(responseData: expectedString.data(using: .utf8), response: nil)

        let dataResponse = try await network.patch(url: url, body: nil)
        let data = try XCTUnwrap(dataResponse.data)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, expectedString)
    }
}
