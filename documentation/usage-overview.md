
# Usage Overview

This overview provides a quick introduction to using the key components of the **Later** library. Each section includes simple examples to help you get started with **Later** in your Swift projects.

## SendableValue

`SendableValue` is a thread-safe wrapper for a value that can be safely shared across concurrent tasks. It allows you to set and retrieve the value asynchronously.

### Example

```swift
import Later

let sendableValue = SendableValue<Int>(42)
sendableValue.set(value: 100)
let value = await sendableValue.value
#expect(value == 100)
```

This example shows how to use `SendableValue` to safely manage a mutable state across different contexts in concurrent programming.

## Future

A `Future` represents a value that will be available asynchronously in the future. It allows you to work with values that are not immediately available.

### Example

```swift
import Later

@Sendable func asyncTask() async throws -> String {
    return "Hello"
}

let future = Future {
    do {
        let result = try await asyncTask()
        return result
    } catch {
        throw error
    }
}

do {
    let result = try await future.value
    print(result)  // Prints "Hello"
} catch {
    print("Error: \(error)")
}
```

This example demonstrates how to create and retrieve a value from a `Future`, which will be available asynchronously.

## Deferred

`Deferred` is similar to `Future` but requires explicit start. It represents a value that will be computed and available asynchronously when explicitly started.

### Example

```swift
import Later

@Sendable func asyncDeferredTask() async throws -> String {
    return "Deferred Hello"
}

var deferred = Deferred {
    do {
        let result = try await asyncDeferredTask()
        return result
    } catch {
        throw error
    }
}

deferred.start()

do {
    let result = try await deferred.value
    print(result)  // Prints "Deferred Hello"
} catch {
    print("Error: \(error)")
}
```

This example shows how to work with `Deferred`, where the task begins only when you explicitly call `start()`.

## Stream

A `Stream` represents an asynchronous sequence of values emitted over time. It’s useful for handling data that updates periodically.

### Example

```swift
import Later

@Sendable func asyncStreamTask1() async throws -> String {
    return "First value"
}

@Sendable func asyncStreamTask2() async throws -> String {
    return "Second value"
}

let stream = Stream<String> { emitter in
    do {
        let value1 = try await asyncStreamTask1()
        emitter.emit(value: value1)
        let value2 = try await asyncStreamTask2()
        emitter.emit(value: value2)
    } catch {
        // Handle error if necessary
    }
}

Task {
    for try await value in stream {
        print(value)  // Prints "First value" and then "Second value"
    }
}
```

This example demonstrates how to use `Stream` to handle sequences of values emitted asynchronously over time.

## Publisher and Subscribing

`Publisher` allows objects to subscribe to changes in data, notifying subscribers when updates occur. This is useful for building reactive systems.

### Example

```swift
import Later

class MySubscriber: Subscribing {
    typealias Value = String
    
    func didUpdate(newValue: String?) {
        print("New value: \(String(describing: newValue))")
    }
}

let subscriber = MySubscriber()
let publisher = Publisher(initialValue: "Initial value", subscribers: [subscriber])

// Using Future with Publisher
let future = await publisher.future(
    didSucceed: nil,
    didFail: nil,
    task: {
        return "Future value"
    }
)

do {
    let value = try await future.value
    print("Future completed with value: \(value)")
} catch {
    print("Future failed with error: \(error)")
}

// Using Deferred with Publisher
var deferred = await publisher.deferred(
    didSucceed: nil,
    didFail: nil,
    task: {
        return "Deferred value"
    }
)

deferred.start()

do {
    let value = try await deferred.value
    print("Deferred completed with value: \(value)")
} catch {
    print("Deferred failed with error: \(error)")
}

// Using Stream with Publisher
let stream = await publisher.stream(
    didSucceed: nil,
    didFail: nil,
    task: { emitter in
        emitter.emit(value: "Stream value 1")
        emitter.emit(value: "Stream value 2")
    }
)

var streamValues: [String] = []
for try await value in stream {
    streamValues.append(value)
    print("Stream emitted value: \(value)")
}

print("Stream completed with values: \(streamValues)")
```

This example illustrates how to use `Publisher` and `Subscribing` to create reactive systems that respond to data changes.

## Schedule Task

**Later** also provides the ability to schedule tasks to be executed after a specified duration using the `Task` extension.

### Example

```swift
import Later

func asyncScheduledTask() async throws {
    print("Task executed")
}

do {
    try await Task.schedule(for: .seconds(5)) {
        try await asyncScheduledTask()
    }
} catch {
    print("Failed to execute task: \(error)")
}
```

This example shows how to schedule a task to run after a delay.

## Next Steps

For more in-depth details on each component, refer to the specific usage guides:

- [SendableValue Usage](usage-sendablevalue.md)
- [Future Usage](usage-future.md)
- [Deferred Usage](usage-deferred.md)
- [Stream Usage](usage-stream.md)
- [Publisher and Subscribing Usage](usage-publisher.md)
- [Schedule Task Usage](usage-schedule-task.md)

These guides will help you explore each feature of **Later** in more detail and provide additional examples.
