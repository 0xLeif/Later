import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/**
 This protocol defines the basic structure of an endpoint in a HTTP network request.

 - Note:
    This protocol requires any conforming type to provide the necessary properties for constructing a HTTP request.

 - Properties:
    - `url`: The base URL for the endpoint.
    - `method`: The HTTP request method (GET, POST, etc.)
    - `path`: The path component of the URL.
    - `headers`: The HTTP headers to include in the request.
    - `body`: The body of the HTTP request, if any.
 */
public protocol Endpoint: Hashable {
    /// The base URL for the endpoint.
    static var url: URL { get }

    /// The HTTP request method (GET, POST, etc.)
    var method: HTTPRequestMethod { get }

    /// The path component of the URL.
    var path: String { get }

    /// The HTTP headers to include in the request.
    var headers: [String: String] { get }

    /// The body of the HTTP request, if any.
    var body: Data? { get }
}
