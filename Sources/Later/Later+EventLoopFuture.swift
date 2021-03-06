//
//  Later+EventLoopFuture.swift
//  Later
//
//  Created by Zach Eriksen on 10/2/20.
//

import NIO

public extension Later {
    static func andAllComplete<Value>(_ futures: [EventLoopFuture<Value>]) -> EventLoopFuture<Void> {
        EventLoopFuture.andAllComplete(futures, on: Later.default.ev)
    }
    
    static func andAllSucceed<Value>(_ futures: [EventLoopFuture<Value>]) -> EventLoopFuture<Void> {
        EventLoopFuture.andAllSucceed(futures, on: Later.default.ev)
    }
    
    static func whenAllComplete<Value>(_ futures: [EventLoopFuture<Value>]) -> EventLoopFuture<[Result<Value, Error>]> {
        EventLoopFuture.whenAllComplete(futures, on: Later.default.ev)
    }
    
    static func whenAllSucceed<Value>(_ futures: [EventLoopFuture<Value>]) -> EventLoopFuture<[Value]> {
        EventLoopFuture.whenAllSucceed(futures, on: Later.default.ev)
    }
}
