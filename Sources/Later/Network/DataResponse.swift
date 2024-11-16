import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Represents a response containing data and a URL response.
public struct DataResponse {
    /// The data received in the response.
    public let data: Data?

    /// The URL response received from the server.
    public let response: URLResponse?

    /// Initializes a `DataResponse` with the given data and URL response.
    /// - Parameters:
    ///   - data: The data received in the response.
    ///   - response: The URL response received from the server.
    public init(data: Data?, response: URLResponse?) {
        self.data = data
        self.response = response
    }

    /// Initializes a `DataResponse` with a tuple containing data and URL response.
    /// - Parameters:
    ///   - tuple: A tuple containing data as the first element and URL response as the second element.
    public init(_ tuple: (Data?, URLResponse?)) {
        self.init(data: tuple.0, response: tuple.1)
    }
}
