
# Deferred Usage

`Deferred` is a component of the **Later** library that represents a value that will be computed and available asynchronously when explicitly started. Unlike `Future`, a `Deferred` task does not start until you explicitly call `start()`.

## Overview

A `Deferred` is ideal for scenarios where you want more control over when an asynchronous operation begins. It allows you to define the operation upfront but defer its execution until a later point in your code.

### Key Features

- **Deferred Execution**: The task only begins when `start()` is called.
- **Explicit Control**: You have more control over the timing of the task execution.
- **Error Handling**: Like `Future`, `Deferred` allows for handling errors during task execution and when accessing the result.
- **Cancellation**: A `Deferred` task can only be canceled during its execution.

## Example Usage

### Creating a Deferred Task

You can create a `Deferred` by defining an asynchronous task that will start only when explicitly triggered.

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
```

### Starting the Deferred Task

To execute the task, call the `start()` method on the `Deferred` object.

```swift
deferred.start()
```

### Accessing the Value

You can access the result of a `Deferred` task using the `value` property. This is an asynchronous operation that suspends until the task completes.

```swift
do {
    let result = try await deferred.value
    print(result)  // Prints "Deferred Hello" if the task succeeded
} catch {
    print("Error: \(error)")  // Handles any errors that occurred during execution
}
```

### Handling Success and Failure

You can pass `didSucceed` and `didFail` closures to a `Deferred` to handle the outcome of the task. These closures are executed when the task completes, before the value is accessed.

```swift
var deferred = Deferred(
    didSucceed: { value in
        print("Task succeeded with value: \(value)")
    },
    didFail: { error in
        print("Task failed with error: \(error)")
    },
    task: {
        try await asyncDeferredTask()
    }
)
```

### Cancellation

A `Deferred` task can be canceled before it completes. If you try to access the value of a canceled `Deferred`, it will throw a `CancellationError`.

```swift
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
    _ = try #require(error as? CancellationError)
}
```

## Builder Pattern

The `Deferred` component in **Later** also supports a builder pattern, allowing for more complex configurations before the `Deferred` is built and executed.

### Example Using the Builder

```swift
import Later

var deferred = Deferred<String>.Builder {
    try await Task.catNap()
    return "Data fetched"
}
.onSuccess { value in
    print("Successfully fetched: \(value)")
}
.onFailure { error in
    print("Failed with error: \(error)")
}
.build()

deferred.start()

let result = try await deferred.value
print(result)  // Prints "Data fetched"
```

### Error Handling in Builder

The builder pattern allows you to specify success and failure handlers, which are invoked based on the task's outcome.

```swift
var deferred = Deferred<String>.Builder {
    try await Task.catNap()
    throw DeferredError.mockError
}
.onSuccess { _ in
    Issue.record("Deferred should not succeed")
}
.onFailure { error in
    print("Failed with error: \(error)")
}
.build()

deferred.start()

do {
    _ = try await deferred.value
    Issue.record("Task should throw an error")
} catch {
    print("Caught error: \(error)")
}
```

In this example, the `Deferred` is configured with a task that throws an error. The `onFailure` closure handles this error, while the `onSuccess` closure is not called.

## Best Practices

- **Use When Execution Timing Matters**: Utilize `Deferred` when you need control over when an asynchronous task starts.
- **Handle Cancellations**: Consider the possibility of a `Deferred` task being canceled and handle `CancellationError` appropriately.
- **Leverage the Builder**: Use the builder pattern for more complex `Deferred` configurations, especially when you need custom success or failure handling.

## Conclusion

`Deferred` is a powerful tool for managing asynchronous operations that require explicit control over their start time. It simplifies the process of handling tasks that need to be deferred, with built-in support for error handling, cancellation, and flexible configuration through the builder pattern. Explore other components of the **Later** library, such as [Future](usage-future.md) and [Stream](usage-stream.md), to continue building your asynchronous programming skills.
