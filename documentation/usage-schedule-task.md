# Task Scheduling Extension

This extension to the `Task` class provides a convenient way to schedule a task to be executed after a specified duration. It is particularly useful for scenarios where you need to delay the execution of a task for a specific period.

## Overview

The `Task.schedule` function allows you to define a task that will execute after a specified duration. This is especially useful for timed operations, such as delaying a retry attempt or performing an operation after a certain amount of time has passed.

### Key Features

- **Delayed Execution**: Execute a task after a specified duration.
- **Tolerance Handling**: Optionally specify a tolerance for the duration.
- **Clock Customization**: Use a custom clock for measuring the duration.
- **Error Handling**: Handles errors that might occur during task execution or if the sleep is interrupted.

## Example Usage

Here is an example of how to use `Task.schedule` to execute a task after a delay of 5 seconds:

```swift
do {
    try await Task.schedule(for: .seconds(5)) {
        print("Task executed after 5 seconds")
    }
} catch {
    print("Failed to execute task: \(error)")
}
```

In this example, the task prints a message to the console after waiting for 5 seconds. If the task fails or the sleep is interrupted, the error is caught and handled.

### Parameters

- `duration`: The duration to wait before executing the task. This parameter defines how long the task will be delayed.
- `tolerance`: An optional tolerance for the duration. This allows for a small variation in the timing if needed.
- `clock`: The clock to use for measuring the duration. Defaults to `ContinuousClock`, which provides a continuous time reference that is ideal for most scheduling tasks.
- `task`: The task to execute after the specified duration. This is an asynchronous function that can throw errors.

### Availability

This method is available on the following platforms:
- macOS 13.0 or newer
- iOS 16.0 or newer
- watchOS 9.0 or newer
- tvOS 16.0 or newer

Ensure that your project targets the appropriate platform versions to use this feature.
