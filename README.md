# Later

**Later** is a Swift 6 library that simplifies asynchronous programming by offering simple building blocks for managing concurrency. **Later** helps you write clean, maintainable code that efficiently handles complex asynchronous tasks.

## Key Features

**Later** offers a range of tools to make asynchronous programming more straightforward and efficient:

- **SendableValue**: A generic [`Sendable`](https://developer.apple.com/documentation/swift/sendable) value that ensures thread safety using [`OSAllocatedUnfairLock`](https://developer.apple.com/documentation/os/osallocatedunfairlock).
- **Future**: Represents a value that will be available asynchronously in the future, enabling you to handle tasks that take time to complete.
- **Deferred**: Represents a value that will be computed and available asynchronously when explicitly started, giving you control over when a task begins.
- **Stream**: Represents an asynchronous sequence of values emitted over time, perfect for handling data that updates periodically.
- **Publisher**: Allows objects to subscribe to changes in state or data, notifying subscribers when updates occur, ensuring your application responds dynamically to changes.
- **Subscribing**: A protocol for objects that want to observe changes in state or data, making it easy to react to updates.

## Getting Started

To start using **Later**, follow our [Installation Guide](documentation/installation.md) which provides step-by-step instructions for adding **Later** to your Swift project using Swift Package Manager.

After installation, explore our [Usage Overview](03-usage-overview.md) to see how to implement each of the key features in your own code. From simple examples to more in-depth explorations, these guides will help you integrate **Later** into your asynchronous workflows effectively.

## Documentation

Here’s a breakdown of the **Later** documentation:

- [Installation Guide](01-installation.md): Instructions on how to install **Later** using Swift Package Manager.
- [Usage Overview](03-usage-overview.md): An overview of **Later**'s key features with example implementations.
- Detailed Usage Guides:
  - [SendableValue Usage](usage-sendablevalue.md)
  - [Future Usage](usage-future.md)
  - [Deferred Usage](usage-deferred.md)
  - [Stream Usage](usage-stream.md)
  - [Publisher and Subscribing Usage](usage-publisher.md)
  - [Schedule Task Usage](usage-schedule-task.md)
- [Contributing](contributing.md): Information on how to contribute to the **Later** project.

## Next Steps

To continue, head over to our [Installation Guide](01-installation.md) and get **Later** set up in your project. After installation, you can dive into the [Usage Overview](03-usage-overview.md) to see how to start leveraging the power of asynchronous programming with **Later**.
