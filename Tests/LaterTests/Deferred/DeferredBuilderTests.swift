import Testing
@testable import Later

struct DeferredBuilderTests {
    enum DeferredError: Error {
        case mockError
    }

    @Test func testDeferredSuccess() async throws {
        var deferred = Deferred<String>
            .Builder {
                try await Task.catNap()
                return "Data fetched"
            }
            .onSuccess { value in
                #expect(value == "Data fetched")
            }
            .onFailure { _ in
                Issue.record("Deferred should not fail")
            }
            .build()

        deferred.start()

        let result = try await deferred.value
        #expect(result == "Data fetched")
    }

    @Test func testDeferredFailure() async throws {
        var deferred = Deferred<String>
            .Builder {
                try await Task.catNap()
                throw DeferredError.mockError
            }
            .onSuccess { _ in
                Issue.record("Deferred should not succeed")
            }
            .onFailure { error in
                let error = try? #require(error as? DeferredError)
                #expect(error == DeferredError.mockError)
            }
            .build()

        deferred.start()

        do {
            _ = try await deferred.value
            Issue.record("Task should throw an error")
        } catch {
            let error = try #require(error as? DeferredError)
            #expect(error == DeferredError.mockError)
        }
    }
}
