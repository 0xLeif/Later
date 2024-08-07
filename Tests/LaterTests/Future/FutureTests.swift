import Testing
@testable import Later

struct FutureTests {
    enum FutureError: Error {
        case mockError
    }

    @Test func testFutureTask() async throws {
        let future = Future {
            try await Task.catNap()
            return "Data fetched"
        }

        let result = try await future.value
        #expect(result == "Data fetched")
    }

    @Test func testFutureSuccess() async throws {
        let future = Future(
            didSucceed: { value in
                #expect(value == "Data fetched")
            },
            task: {
                try await Task.catNap()
                return "Data fetched"
            }
        )

        let result = try await future.value
        #expect(result == "Data fetched")
    }

    @Test func testFutureFailure() async throws {
        let future = Future(
            didSucceed: { _ in
                Issue.record("Task should not succeed")
            },
            didFail: { error in
                let error = try? #require(error as? FutureError)
                #expect(error == FutureError.mockError)
            },
            task: {
                try await Task.catNap()
                throw FutureError.mockError
            }
        )

        do {
            _ = try await future.value
            Issue.record("Task should throw an error")
        } catch {
            let error = try #require(error as? FutureError)
            #expect(error == FutureError.mockError)
        }
    }

    @Test func testFutureCancellation() async throws {
        let future = Future<String> {
            try await Task.catNap()
            return "Completed"
        }

        future.cancel()

        do {
            _ = try await future.value
            Issue.record("Future should have been canceled")
        } catch {
            _ = try #require(error as? CancellationError)
        }
    }
}
