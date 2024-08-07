import Testing
@testable import Later

struct DeferredTests {
    enum DeferredError: Error {
        case mockError
    }
    
    @Test func testDeferredSuccess() async throws {
        var deferred = Deferred<String>(
            didSucceed: { value in
                #expect(value == "Data fetched")
            },
            didFail: { _ in
                Issue.record("Deferred should not fail")
            },
            task: {
                try await Task.catNap()
                return "Data fetched"
            }
        )
        
        deferred.start()
        
        let result = try await deferred.value
        #expect(result == "Data fetched")
    }
    
    @Test func testDeferredFailure() async throws {
        var deferred = Deferred<String>(
            didSucceed: { _ in
                Issue.record("Deferred should not succeed")
            },
            didFail: { error in
                let error = try? #require(error as? DeferredError)
                #expect(error == DeferredError.mockError)
            },
            task: {
                try await Task.catNap()
                throw DeferredError.mockError
            }
        )
        
        deferred.start()
        
        do {
            _ = try await deferred.value
            Issue.record("Task should throw an error")
        } catch {
            let error = try #require(error as? DeferredError)
            #expect(error == DeferredError.mockError)
        }
    }
    
    @Test func testDeferredCancellation() async throws {
        var deferred = Deferred<String> {
            try await Task.catNap()
            return "Completed"
        }
        
        deferred.start()
        
        deferred.cancel()
        
        do {
            _ = try await deferred.value
            Issue.record("Deferred should have been canceled")
        } catch {
            #expect((error as? CancellationError) != nil)
        }
    }
}
