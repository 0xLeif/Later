import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A protocol defining networking methods for making HTTP requests.
public protocol Networking {
    /// Sends an HTTP request to the specified URL.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - method: The HTTP method to be used.
    ///   - headerFields: Header fields to include in the request.
    ///   - body: Optional body to be including with the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    func request(
        for url: URL,
        method : HTTPRequestMethod,
        headerFields: [String: String],
        body: Data?
    ) async throws -> DataResponse

    /// Sends an HTTP GET request to the specified URL.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - headerFields: Optional header fields to include in the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    func `get`(
        url: URL,
        headerFields: [String: String]
    ) async throws -> DataResponse

    /// Sends an HTTP HEAD request to the specified URL.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - headerFields: Optional header fields to include in the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    func head(
        url: URL,
        headerFields: [String: String]
    ) async throws -> DataResponse

    /// Sends an HTTP CONNECT request to the specified URL.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - headerFields: Optional header fields to include in the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    func connect(
        url: URL,
        headerFields: [String: String]
    ) async throws -> DataResponse

    /// Sends an HTTP OPTIONS request to the specified URL.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - headerFields: Optional header fields to include in the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    func options(
        url: URL,
        headerFields: [String: String]
    ) async throws -> DataResponse

    /// Sends an HTTP TRACE request to the specified URL.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - headerFields: Optional header fields to include in the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    func trace(
        url: URL,
        headerFields: [String: String]
    ) async throws -> DataResponse

    /// Sends an HTTP POST request to the specified URL.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - body: The data to be included in the request body.
    ///   - headerFields: Optional header fields to include in the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    func post(
        url: URL,
        body: Data?,
        headerFields: [String: String]
    ) async throws -> DataResponse

    /// Sends an HTTP PUT request to the specified URL.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - body: The data to be included in the request body.
    ///   - headerFields: Optional header fields to include in the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    func put(
        url: URL,
        body: Data?,
        headerFields: [String: String]
    ) async throws -> DataResponse

    /// Sends an HTTP PATCH request to the specified URL.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - body: The data to be included in the request body.
    ///   - headerFields: Optional header fields to include in the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    func patch(
        url: URL,
        body: Data?,
        headerFields: [String: String]
    ) async throws -> DataResponse

    /// Sends an HTTP DELETE request to the specified URL.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - body: The data to be included in the request body.
    ///   - headerFields: Optional header fields to include in the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    func delete(
        url: URL,
        body: Data?,
        headerFields: [String: String]
    ) async throws -> DataResponse
}
