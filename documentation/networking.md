# Networking

### Performing a GET Request

```swift
import Network

let network = Network()

do {
    let dataResponse = try await network.get(url: URL(string: "https://api.example.com/posts")!)

    if let data = dataResponse.data {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        print(json)
    } else {
        print("No response data")
    }
} catch {
    print("Error: \(error)")
}
```

### Sending a POST Request

```swift
import Network

let network = Network()

do {
    let headers = ["Authorization": "Bearer your-token"]
    let body: [String: Any] = [
        "name": "John Doe",
        "email": "johndoe@example.com"
    ]

    let dataResponse = try await network.post(
        url: URL(string: "https://api.example.com/users")!,
        headerFields: headers,
        body: body
    )

    if let data = dataResponse.data {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        print(json)
    }
} catch {
    print("Error: \(error)")
}

```

### Defining an API

In order to define an API, you must first create an `Endpoint`. This is a protocol that outlines the basic components of a network request. These components include the URL, HTTP request method, path, headers, and body of the request.

Here's an example of an `Endpoint`:

```swift
enum ExampleEndpoint: Endpoint {
    static var url: URL { URL(string: "example.com")! }

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

```

Once the `Endpoint` is defined, you can create an instance of `API` or `MockAPI` (for testing) to send requests to the endpoint. Here's how you can use the `MockAPI` in a test:

```swift
func testAPI() async throws {
    let api = MockAPI<ExampleEndpoint>()
    let expectedString = "hello"

    let dataResponse = try await api.request(.hello)
    let data = try XCTUnwrap(dataResponse.data)
    let string = String(data: data, encoding: .utf8)

    XCTAssertEqual(string, expectedString)
}

```

The above test creates a `MockAPI`, sends a `GET` request to the `hello` endpoint, and checks if the response matches the expected string "hello".
