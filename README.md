# Later

`Later` is a lightweight Swift 6 library designed to simplify asynchronous programming by providing foundational building blocks such as `Future`, `Deferred`, `Stream`, `SendableValue`, and `Publisher`. These components enable you to manage and coordinate asynchronous tasks, making it easier to write clean and maintainable code.

## Features

- **Future**: Represents a value that will be available asynchronously in the future.
- **Deferred**: Represents a value that will be computed and available asynchronously when explicitly started.
- **Stream**: Represents an asynchronous sequence of values emitted over time.
- **Publisher**: Allows objects to subscribe to changes in state or data and notifies subscribers when the state or data changes.
- **Subscribing**: A protocol for objects that want to observe changes in state or data.
- **SendableValue**: A generic [`Sendable`](https://developer.apple.com/documentation/swift/sendable) value that uses [`OSAllocatedUnfairLock`](https://developer.apple.com/documentation/os/osallocatedunfairlock).

## Installation

### Swift Package Manager

Add `Later` to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/0xLeif/Later.git", from: "1.0.0")
]
```

And add it to your target’s dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["Later"]
)
```

## Usage

### Future

A `Future` represents a value that will be available asynchronously in the future.

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

### Deferred

A `Deferred` represents a value that will be computed and available asynchronously when explicitly started.

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

### Stream

A `Stream` represents an asynchronous sequence of values emitted over time.

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

### Publisher and Subscribing

A `Publisher` allows objects to subscribe to changes in data and notifies subscribers when the data changes.

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

### Schedule Task

You can schedule tasks to be executed after a specified duration using the `Task` extension.

Availability: `@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)`

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

### SendableValue

SendableValue is a thread-safe wrapper for a value that can be safely shared across concurrent tasks. It allows you to set and retrieve the value asynchronously.

```swift
let sendableValue = SendableValue<Int>(42)
sendableValue.set(value: 100)
let value = await sendableValue.value
#expect(value == 100)
```

This ensures that the value is safely managed across different contexts, providing a simple way to handle mutable state in concurrent programming.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you have any suggestions or bug reports. Please create an issue before submitting any pull request to make sure the work isn’t already being worked on by someone else.
