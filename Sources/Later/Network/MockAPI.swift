/**
 An open class that inherits from the base API class. It overrides the request method
 to use a mock network for testing purposes.

 - Parameter APIEndpoint: The endpoint where the API will point.
 - Returns: A mocked data response for testing.

 Usage:

 ```swift
 let mockAPI = MockAPI<MyEndpoint>()
 let response = try await mockAPI.request(.someEndpoint)

 ```

 This will return a mock response using the data provided in the mockEndpoint body.
 */
open class MockAPI<APIEndpoint: Endpoint>: API<APIEndpoint> {
    /**

    Sends an asynchronous network request to a specific API endpoint using a mock network.

    - Parameter endpoint: The API endpoint to which the request will be sent.

    - Throws: If there is an error during the network request.

    - Returns: A mocked data response for testing. The data will just be the body of the request and there will be no response.

    */
    open override func request(_ endpoint: APIEndpoint) async throws -> DataResponse {
        try await MockNetwork(
            responseData: endpoint.body,
            response: nil
        )
        .request(
            for: APIEndpoint.url.appending(path: endpoint.path),
            method: endpoint.method,
            headerFields: endpoint.headers,
            body: endpoint.body
        )
    }
}
