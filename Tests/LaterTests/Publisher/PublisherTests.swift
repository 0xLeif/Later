#if !os(Linux) && !os(Windows)
import Testing
@testable import Later

final class TestSubscriber: Subscribing, Sendable {
    typealias Value = String
    let observedValues: SendableValue<[String?]> = SendableValue([])

    func didUpdate(newValue: String?) {
        observedValues.update { values in
            values.append(newValue)
        }
    }
}

struct PublisherTests {
    enum TestError: Error {
        case mockError
    }

    @Test func testPublisherNotifiesSubscribers() async throws {
        let publisher = Publisher<String?>(initialValue: "Initial value")
        let testSubscriber = TestSubscriber()
        await publisher.add(subscriber: testSubscriber)

        await publisher.update(value: "Updated value")

        let values = await testSubscriber.observedValues.value
        #expect(values == ["Initial value", "Updated value"])
    }

    @Test func testPublisherHandlesMultipleSubscribers() async throws {
        let publisher = Publisher<String?>(initialValue: "Initial value")
        let testSubscriber1 = TestSubscriber()
        let testSubscriber2 = TestSubscriber()

        await publisher.add(subscriber: testSubscriber1)
        await publisher.add(subscriber: testSubscriber2)

        await publisher.update(value: "Updated value")

        let values1 = await testSubscriber1.observedValues.value
        let values2 = await testSubscriber2.observedValues.value

        #expect(values1 == ["Initial value", "Updated value"])
        #expect(values2 == ["Initial value", "Updated value"])
    }

    @Test func testPublisherHandlesNoObservers() async throws {
        let publisher = Publisher<String?>(initialValue: "Initial value")
        await publisher.update(value: "Updated value")

        let currentValue = await publisher.currentValue
        #expect(currentValue == "Updated value")
    }

    @Test func testPublisherWithFuture() async throws {
        let publisher = Publisher<String?>()
        let testSubscriber = TestSubscriber()
        await publisher.add(subscriber: testSubscriber)

        let future = await publisher.future(
            didSucceed: nil,
            didFail: nil,
            task: {
                try await Task.catNap()
                return "Future completed"
            }
        )

        let value = try await future.value
        let values = await testSubscriber.observedValues.value

        #expect(values == [nil, "Future completed"])
        #expect(value == "Future completed")
    }

    @Test func testPublisherWithDeferred() async throws {
        let publisher = Publisher<String?>()
        let testSubscriber = TestSubscriber()
        await publisher.add(subscriber: testSubscriber)

        var deferred = await publisher.deferred(
            didSucceed: nil,
            didFail: nil,
            task: {
                try await Task.catNap()
                return "Deferred completed"
            }
        )

        deferred.start()

        let value = try await deferred.value
        let values = await testSubscriber.observedValues.value

        #expect(values == [nil, "Deferred completed"])
        #expect(value == "Deferred completed")
    }

    @Test func testPublisherWithStream() async throws {
        let publisher = Publisher<String?>()
        let testSubscriber = TestSubscriber()
        await publisher.add(subscriber: testSubscriber)

        let stream = await publisher.stream(
            didSucceed: nil,
            didFail: nil,
            task: { emitter in
                try await Task.catNap()
                emitter.emit(value: "Stream value 1")
                try await Task.catNap()
                emitter.emit(value: "Stream value 2")
            }
        )

        // Collect stream values
        var streamValues: [String?] = []

        for try await value in stream {
            streamValues.append(value)
        }

        // Wait for the stream to emit values
        try await Task.catNap()

        let values = await testSubscriber.observedValues.value
        #expect(values == [nil, "Stream value 1", "Stream value 2"])
        #expect(streamValues == ["Stream value 1", "Stream value 2"])
    }

    @Test func testPublisherRemovesObservers() async throws {
        let publisher = Publisher<String?>(initialValue: "Initial value")
        let testSubscriber1 = TestSubscriber()
        let testSubscriber2 = TestSubscriber()

        await publisher.add(subscriber: testSubscriber1)
        await publisher.add(subscriber: testSubscriber2)
        await publisher.update(value: "Updated value")

        await publisher.remove(subscriber: testSubscriber1)
        await publisher.update(value: "Final value")

        let values1 = await testSubscriber1.observedValues.value
        let values2 = await testSubscriber2.observedValues.value

        #expect(values1 == ["Initial value", "Updated value"])
        #expect(values2 == ["Initial value", "Updated value", "Final value"])
    }

    @Test func testPublisherHandlesObserverRemovalDuringUpdate() async throws {
        let publisher = Publisher<String?>(initialValue: "Initial value")
        let testSubscriber1 = TestSubscriber()
        let testSubscriber2 = TestSubscriber()

        await publisher.add(subscriber: testSubscriber1)
        await publisher.add(subscriber: testSubscriber2)

        await publisher.update(value: "Updated value")
        await publisher.remove(subscriber: testSubscriber1)
        await publisher.update(value: "Final value")

        let values1 = await testSubscriber1.observedValues.value
        let values2 = await testSubscriber2.observedValues.value

        #expect(values1 == ["Initial value", "Updated value"])
        #expect(values2 == ["Initial value", "Updated value", "Final value"])
    }

    @Test func testPublisherAddedAfterValueChange() async throws {
        let publisher = Publisher<String?>(initialValue: "Initial value")
        await publisher.update(value: "Updated value")

        let testSubscriber = TestSubscriber()
        await publisher.add(subscriber: testSubscriber)

        let values = await testSubscriber.observedValues.value
        #expect(values == ["Updated value"])
    }

    @Test func testPublisherConcurrentUpdates() async throws {
        let publisher = Publisher<String?>()
        let testSubscriber = TestSubscriber()
        await publisher.add(subscriber: testSubscriber)

        let tasks = (1...10).map { i in
            Task {
                await publisher.update(value: "Update \(i)")
            }
        }

        for task in tasks {
            await task.value
        }

        let values = await testSubscriber.observedValues.value
        #expect(values.count == 11)  // 1 initial nil + 10 updates
    }

    @Test func testPublisherHandlesNilValues() async throws {
        let publisher = Publisher<String?>()
        let testSubscriber = TestSubscriber()
        await publisher.add(subscriber: testSubscriber)

        await publisher.update(value: nil)
        await publisher.update(value: "Non-nil value")
        await publisher.update(value: nil)

        let values = await testSubscriber.observedValues.value
        #expect(values == [nil, nil, "Non-nil value", nil])
    }

    @Test func testPublisherMultipleRapidUpdates() async throws {
        let publisher = Publisher<String?>()
        let testSubscriber = TestSubscriber()
        await publisher.add(subscriber: testSubscriber)

        await publisher.update(value: "Value 1")
        await publisher.update(value: "Value 2")
        await publisher.update(value: "Value 3")

        let values = await testSubscriber.observedValues.value
        #expect(values == [nil, "Value 1", "Value 2", "Value 3"])
    }

    @Test func testPublisherConcurrentAddRemoveObservers() async throws {
        let publisher = Publisher<String?>()
        let testSubscriber = TestSubscriber()

        let addRemoveTasks = (1...10).map { _ in
            Task {
                await publisher.add(subscriber: testSubscriber)
                await publisher.remove(subscriber: testSubscriber)
            }
        }

        for task in addRemoveTasks {
            await task.value
        }

        // Add observer at the end to ensure it is observing the final state
        await publisher.add(subscriber: testSubscriber)
        await publisher.update(value: "Final value")

        let values = await testSubscriber.observedValues.value
        #expect(values.last == "Final value")
        #expect(values.count == 12)  // Expect 10 nils from concurrent adds/removes + final add & final value
    }

    @Test func testPublisherConcurrentAddObserversDuringUpdate() async throws {
        let publisher = Publisher<String?>()
        let testSubscriber1 = TestSubscriber()
        let testSubscriber2 = TestSubscriber()

        let concurrentTasks = (1...5).map { i in
            Task {
                await publisher.add(subscriber: testSubscriber1)
                await publisher.update(value: "Update \(i)")
            }
        }

        // Await completion of concurrent tasks
        for task in concurrentTasks {
            await task.value
        }

        await publisher.remove(subscriber: testSubscriber1)

        // Add observer at the end to ensure it is observing the final state
        await publisher.add(subscriber: testSubscriber2)
        await publisher.update(value: "Final value")

        let values1 = await testSubscriber1.observedValues.value
        let values2 = await testSubscriber2.observedValues.value

        // Ensure values1 contains all updates except for the final
        #expect(values1.count == 10)
        #expect(values1.contains(nil))
        #expect(values1.contains("Update 1"))
        #expect(values1.contains("Update 2"))
        #expect(values1.contains("Update 3"))
        #expect(values1.contains("Update 4"))
        #expect(values1.contains("Update 5"))

        // Ensure values2 contains "Final value"
        #expect(values2.count == 2)
        #expect(values2.contains("Final value"))
    }

    @Test func testPublisherHighContention() async throws {
        let publisher = Publisher<String?>()
        let testSubscriber = TestSubscriber()
        await publisher.add(subscriber: testSubscriber)

        let tasks = (1...100).map { i in
            Task {
                if i % 2 == 0 {
                    await publisher.update(value: "Even \(i)")
                } else {
                    await publisher.update(value: "Odd \(i)")
                }
            }
        }

        for task in tasks {
            await task.value
        }

        let values = await testSubscriber.observedValues.value
        #expect(values.count == 101)  // 1 initial nil + 100 updates
    }

    @Test func testPublisherEdgeCaseHandling() async throws {
        let publisher = Publisher<String?>(initialValue: "Initial value")
        let testSubscriber = TestSubscriber()
        await publisher.add(subscriber: testSubscriber)

        await publisher.update(value: nil)
        await publisher.update(value: "Edge case value")
        await publisher.update(value: nil)

        let values = await testSubscriber.observedValues.value
        #expect(values == ["Initial value", nil, "Edge case value", nil])
    }
}
#endif
