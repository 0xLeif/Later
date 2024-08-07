import Testing
@testable import Later

struct StreamTests {
    @Test func testStreamEmitsValues() async throws {
        let stream = Stream<String> { emitter in
            try await Task.catNap()
            emitter.emit(value: "First value")
            try await Task.catNap()
            emitter.emit(value: "Second value")
        }

        var values: [String] = []
        try await stream.forEach { value in
            values.append(value)
        }

        #expect(values == ["First value", "Second value"])
    }

    @Test func testStreamMap() async throws {
        let stream = Stream<String> { emitter in
            try await Task.catNap()
            emitter.emit(value: "First value")
            try await Task.catNap()
            emitter.emit(value: "Second value")
        }

        let mappedStream = stream.map { value in
            "Mapped \(value)"
        }

        var values: [String] = []
        try await mappedStream.forEach { value in
            values.append(value)
        }

        #expect(values == ["Mapped First value", "Mapped Second value"])
    }

    @Test func testStreamFilter() async throws {
        let stream = Stream<String> { emitter in
            try await Task.catNap()
            emitter.emit(value: "First value")
            try await Task.catNap()
            emitter.emit(value: "Second value")
        }

        let filteredStream = stream.filter { value in
            value.contains("First")
        }

        var values: [String] = []
        try await filteredStream.forEach { value in
            values.append(value)
        }

        #expect(values == ["First value"])
    }

    @Test func testStreamCompactMap() async throws {
        let stream = Stream<String> { emitter in
            try await Task.catNap()
            emitter.emit(value: "First value")
            try await Task.catNap()
            emitter.emit(value: "Second value")
        }

        let compactMappedStream = stream.compactMap { value in
            value.contains("Second") ? nil : "CompactMapped \(value)"
        }

        var values: [String] = []
        try await compactMappedStream.forEach { value in
            values.append(value)
        }

        #expect(values == ["CompactMapped First value"])
    }

    @Test func testStreamReduce() async throws {
        let stream = Stream<String> { emitter in
            try await Task.catNap()
            emitter.emit(value: "First value")
            try await Task.catNap()
            emitter.emit(value: "Second value")
        }

        let result = try await stream.reduce("") { result, value in
            result + value + " "
        }

        #expect(result == "First value Second value ")
    }

    @Test func testStreamReduceInto() async throws {
        let stream = Stream<String> { emitter in
            try await Task.catNap()
            emitter.emit(value: "First value")
            try await Task.catNap()
            emitter.emit(value: "Second value")
        }

        let result = try await stream.reduce(into: "") { result, value in
            result += value + " "
        }

        #expect(result == "First value Second value ")
    }

    @Test func testStreamIntoArray() async throws {
        let stream = Stream<String> { emitter in
            try await Task.catNap()
            emitter.emit(value: "First value")
            try await Task.catNap()
            emitter.emit(value: "Second value")
        }

        let values = try await stream.intoArray()

        #expect(values == ["First value", "Second value"])
    }
}
