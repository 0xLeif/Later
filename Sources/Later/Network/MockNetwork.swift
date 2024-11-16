import Foundation

/// A class that implements the `Networking` protocol to provide mock network responses.
open class MockNetwork: Network {
    private let responseData: Data?
    private let response: URLResponse?

    public init(
        responseData: Data?,
        response: URLResponse?
    ) {
        self.responseData = responseData
        self.response = response
    }

    /// Sends an Mock HTTP request.
    /// - Parameters:
    ///   - url: The URL to which the request will be sent.
    ///   - method: The HTTP method to be used.
    ///   - headerFields: Header fields to include in the request.
    ///   - body: Optional body to be including with the request.
    /// - Returns: A `DataResponse` object containing the response data and URL response.
    public override func request(
        for url: URL,
        method: HTTPRequestMethod,
        headerFields: [String: String],
        body: Data?
    ) async throws -> DataResponse {
        DataResponse(
            data: responseData,
            response: response
        )
    }
}
