import Testing
@testable import Later

struct StreamBuilderTests {
    enum StreamError: Error {
        case mockError
    }
    
    @Test func testStreamBuilderEmitsValues() async throws {
        let stream = Stream<String>
            .Builder { emitter in
                try await Task.catNap()
                emitter.emit(value: "First value")
                try await Task.catNap()
                emitter.emit(value: "Second value")
            }
            .onSuccess {
                #expect(true)
            }
            .onFailure { _ in
                Issue.record("Stream should not fail")
            }
            .build()
        
        var values = [String]()
        do {
            for try await value in stream {
                values.append(value)
            }
        } catch {
            Issue.record("Stream error: \(error)")
        }
        
        #expect(values == ["First value", "Second value"])
    }
    
    @Test func testStreamBuilderHandlesCompletion() async throws {
        let stream = Stream<String>
            .Builder { emitter in
                try await Task.catNap()
                emitter.emit(value: "Only value")
            }
            .onSuccess {
                #expect(true)
            }
            .onFailure { _ in
                Issue.record("Stream should not fail")
            }
            .build()
        
        var values = [String]()
        do {
            for try await value in stream {
                values.append(value)
            }
        } catch {
            Issue.record("Stream error: \(error)")
        }
        
        #expect(values == ["Only value"])
    }
    
    @Test func testStreamBuilderHandlesErrors() async throws {
        let stream = Stream<String>
            .Builder { emitter in
                try await Task.catNap()
                throw StreamError.mockError
            }
            .onSuccess {
                Issue.record("Stream should not complete successfully")
            }
            .onFailure { error in
                #expect((error as! StreamError) == .mockError)
            }
            .build()
        
        var values = [String]()
        var receivedError: Error?
        
        do {
            for try await value in stream {
                values.append(value)
            }
        } catch {
            receivedError = error
        }
        
        #expect(values.isEmpty)
        #expect(receivedError as? StreamError == .mockError)
    }
    
    @Test func testStreamBuilderEmitsValuesWithSuccessOnly() async throws {
        let stream = Stream<String>
            .Builder { emitter in
                try await Task.catNap()
                emitter.emit(value: "First value")
                try await Task.catNap()
                emitter.emit(value: "Second value")
            }
            .onSuccess {
                #expect(true)
            }
            .build()
        
        var values = [String]()
        do {
            for try await value in stream {
                values.append(value)
            }
        } catch {
            Issue.record("Stream error: \(error)")
        }
        
        #expect(values == ["First value", "Second value"])
    }
    
    @Test func testStreamBuilderEmitsValuesWithFailureOnly() async throws {
        let stream = Stream<String>
            .Builder { emitter in
                try await Task.catNap()
                throw StreamError.mockError
            }
            .onFailure { error in
                #expect((error as! StreamError) == .mockError)
            }
            .build()
        
        var values = [String]()
        var receivedError: Error?
        
        do {
            for try await value in stream {
                values.append(value)
            }
        } catch {
            receivedError = error
        }
        
        #expect(values.isEmpty)
        #expect(receivedError as? StreamError == .mockError)
    }
    
    @Test func testStreamBuilderEmitsValuesWithTaskOnly() async throws {
        let stream = Stream<String>
            .Builder { emitter in
                try await Task.catNap()
                emitter.emit(value: "First value")
                try await Task.catNap()
                emitter.emit(value: "Second value")
            }
            .build()
        
        var values = [String]()
        do {
            for try await value in stream {
                values.append(value)
            }
        } catch {
            Issue.record("Stream error: \(error)")
        }
        
        #expect(values == ["First value", "Second value"])
    }
}
