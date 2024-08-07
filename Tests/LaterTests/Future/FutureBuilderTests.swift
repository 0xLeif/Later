import Testing
@testable import Later

struct FutureBuilderTests {
    enum FutureError: Error {
        case mockError
    }
    
    @Test func testFutureTask() async throws {
        let future = Future<String>.Builder {
            try await Task.catNap()
            return "Data fetched"
        }.build()
        
        let result = try await future.value
        #expect(result == "Data fetched")
    }
    
    @Test func testFutureSuccess() async throws {
        let builder = Future<String>.Builder {
            try await Task.catNap()
            return "Data fetched"
        }
        
        let future = builder
            .onSuccess { value in
                #expect(value == "Data fetched")
            }
            .onFailure { _ in
                Issue.record("Task should not fail")
            }
            .build()
        
        let result = try await future.value
        #expect(result == "Data fetched")
    }
    
    @Test func testFutureBuilderCompletesSuccessfully() async throws {
        let future = Future<String>
            .Builder {
                try await Task.catNap()
                return "Completed"
            }
            .onSuccess { value in
                #expect(value == "Completed")
            }
            .build()
        
        let result = try await future.value
        #expect(result == "Completed")
    }
    
    @Test func testFutureFailure() async throws {
        let builder = Future<String>.Builder {
            try await Task.catNap()
            throw FutureError.mockError
        }
        
        let future = builder
            .onSuccess { _ in
                Issue.record("Task should not succeed")
            }
            .onFailure { error in
                let error = try? #require(error as? FutureError)
                #expect(error == FutureError.mockError)
            }
            .build()
        
        do {
            _ = try await future.value
            Issue.record("Task should throw an error")
        } catch {
            let error = try #require(error as? FutureError)
            #expect(error == FutureError.mockError)
        }
    }
}
