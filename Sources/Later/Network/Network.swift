import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A class that implements the `Networking` protocol to perform network requests using URLSession.
open class Network: Networking {
    public weak var delegate: URLSessionTaskDelegate?

    public init(delegate: URLSessionTaskDelegate? = nil) {
        self.delegate = delegate
    }

    open func request(
        for url: URL,
        method : HTTPRequestMethod,
        headerFields: [String: String],
        body: Data?
    ) async throws -> DataResponse {
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headerFields
        request.httpBody = body

        return DataResponse(
            try await URLSession.shared.data(
                for: request,
                delegate: delegate
            )
        )
    }

    open func `get`(
        url: URL,
        headerFields: [String: String] = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
    ) async throws -> DataResponse {
        try await request(
            for: url,
            method: .GET,
            headerFields: headerFields,
            body: nil
        )
    }

    open func head(
        url: URL,
        headerFields: [String: String] = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
    ) async throws -> DataResponse {
        try await request(
            for: url,
            method: .HEAD,
            headerFields: headerFields,
            body: nil
        )
    }

    open func connect(
        url: URL,
        headerFields: [String: String] = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
    ) async throws -> DataResponse {
        try await request(
            for: url,
            method: .CONNECT,
            headerFields: headerFields,
            body: nil
        )
    }

    open func options(
        url: URL,
        headerFields: [String: String] = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
    ) async throws -> DataResponse {
        try await request(
            for: url,
            method: .OPTIONS,
            headerFields: headerFields,
            body: nil
        )
    }

    open func trace(
        url: URL,
        headerFields: [String: String] = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
    ) async throws -> DataResponse {
        try await request(
            for: url,
            method: .TRACE,
            headerFields: headerFields,
            body: nil
        )
    }

    open func post(
        url: URL,
        body: Data?,
        headerFields: [String: String] = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
    ) async throws -> DataResponse {
        try await request(
            for: url,
            method: .POST,
            headerFields: headerFields,
            body: body
        )
    }

    open func put(
        url: URL,
        body: Data?,
        headerFields: [String: String] = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
    ) async throws -> DataResponse {
        try await request(
            for: url,
            method: .PUT,
            headerFields: headerFields,
            body: body
        )
    }

    open func patch(
        url: URL,
        body: Data?,
        headerFields: [String: String] = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
    ) async throws -> DataResponse {
        try await request(
            for: url,
            method: .PATCH,
            headerFields: headerFields,
            body: body
        )
    }

    open func delete(
        url: URL,
        body: Data?,
        headerFields: [String: String] = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
    ) async throws -> DataResponse {
        try await request(
            for: url,
            method: .DELETE,
            headerFields: headerFields,
            body: body
        )
    }
}
