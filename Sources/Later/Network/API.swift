import Foundation

/// An open class that defines the base API. It will request data from a network pointing to a specific API endpoint.
open class API<APIEndpoint: Endpoint> {
    private let network: Networking

    /// Initializes a new instance of the API class.
    public init() {
        network = Network()
    }

    /**
     Sends an asynchronous network request to a specific API endpoint.
     - Parameter endpoint: The API endpoint to which the request will be sent.
     - Throws: If there is an error during the network request.
     - Returns: The data response from the network request.
     */
    open func request(_ endpoint: APIEndpoint) async throws -> DataResponse {
        try await network.request(
            for: APIEndpoint.url.appending(path: endpoint.path),
            method: endpoint.method,
            headerFields: endpoint.headers,
            body: endpoint.body
        )
    }
}
