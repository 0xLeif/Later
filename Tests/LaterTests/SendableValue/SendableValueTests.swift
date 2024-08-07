import Testing
@testable import Later

struct SendableValueTests {
    @Test func testSendableValueInitialValue() async throws {
        let sendableValue = SendableValue<Int>(42)
        let value = await sendableValue.value
        #expect(value == 42)
    }

    @Test func testSendableValueSetValue() async throws {
        let sendableValue = SendableValue<Int>(42)
        sendableValue.set(value: 100)
        let value = await sendableValue.value
        #expect(value == 100)
    }

    @Test func testSendableValueUpdateValue() async throws {
        let sendableValue = SendableValue<Int>(42)
        sendableValue.update { $0 += 1 }
        let value = await sendableValue.value
        #expect(value == 43)
    }

    @Test func testSendableValueConcurrentAccess() async throws {
        let sendableValue = SendableValue<Int>(0)
        let tasks = (1 ... 10).map { i in
            Task {
                sendableValue.update { $0 += i }
            }
        }

        for task in tasks {
            await task.value
        }

        let value = await sendableValue.value
        #expect(value == 55)  // Sum of integers from 1 to 10
    }

    @Test func testSendableValueConcurrentSets() async throws {
        let sendableValue = SendableValue<Int>(0)
        let tasks = (1 ... 10).map { i in
            Task {
                sendableValue.set(value: i)
            }
        }

        for task in tasks {
            await task.value
        }

        let value = await sendableValue.value
        #expect((1 ... 10).contains(value))
    }

@Test func testSendableValueMixedConcurrentOperations() async throws {
    let sendableValue = SendableValue<Int>(0)
    let setTasks = (1 ... 5).map { i in
        Task {
            sendableValue.set(value: i)
        }
    }
    let updateTasks = (6 ... 10).map { i in
        Task {
            sendableValue.update { $0 += i }
        }
    }

    let allTasks = setTasks + updateTasks
    for task in allTasks {
        await task.value
    }

    let value = await sendableValue.value

    // Set values could be overwritten, and update values could vary widely due to concurrency
    // The range includes a reasonable set of expected results considering the operations.
    #expect((1 ... 55).contains(value))
}

    @Test func testSendableValueHighContention() async throws {
        let sendableValue = SendableValue<Int>(0)
        let tasks = (1 ... 1000).map { i in
            Task {
                if i % 2 == 0 {
                    sendableValue.set(value: i)
                } else {
                    sendableValue.update { $0 += i }
                }
            }
        }

        for task in tasks {
            await task.value
        }

        let value = await sendableValue.value
        #expect(value >= 0)  // We expect the value to be non-negative
    }

    @Test func testSendableValueEdgeCase() async throws {
        let sendableValue = SendableValue<Int>(Int.max - 1)
        sendableValue.update { $0 += 1 }
        let value = await sendableValue.value
        #expect(value == Int.max)
    }

    @Test func testSendableValueUnderflow() async throws {
        let sendableValue = SendableValue<Int>(Int.min + 1)
        sendableValue.update { $0 -= 1 }
        let value = await sendableValue.value
        #expect(value == Int.min)
    }

    @Test func testSendableValueConcurrentIncrements() async throws {
        let sendableValue = SendableValue<Int>(0)
        let tasks = (1 ... 1000).map { _ in
            Task {
                sendableValue.update { $0 += 1 }
            }
        }

        for task in tasks {
            await task.value
        }

        let value = await sendableValue.value
        #expect(value == 1000)
    }

    @Test func testSendableValueConcurrentDecrements() async throws {
        let sendableValue = SendableValue<Int>(1000)
        let tasks = (1 ... 1000).map { _ in
            Task {
                sendableValue.update { $0 -= 1 }
            }
        }

        for task in tasks {
            await task.value
        }

        let value = await sendableValue.value
        #expect(value == 0)
    }

    @Test func testSendableValueConcurrentMixedIncrementsAndDecrements() async throws {
        let sendableValue = SendableValue<Int>(0)
        let incrementTasks = (1 ... 500).map { _ in
            Task {
                sendableValue.update { $0 += 1 }
            }
        }
        let decrementTasks = (1 ... 500).map { _ in
            Task {
                sendableValue.update { $0 -= 1 }
            }
        }

        let allTasks = incrementTasks + decrementTasks
        for task in allTasks {
            await task.value
        }

        let value = await sendableValue.value
        #expect(value == 0)
    }
}
