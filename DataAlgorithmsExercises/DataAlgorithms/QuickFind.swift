//
//  QuickFind.swift
//  DataAlgorithms
//
//  Created by anne.freitas on 15/02/23.
//

import Foundation

public final class QuickFind {
    private let N: Int
    public private (set) var items = [Item]()
    
    public enum Error: Swift.Error {
        case invalidN
        case unionPQShouldNotBeEqual
        case unionPQNotFound
    }
    
    // N should be higher than 0
    public init(N: Int) throws {
        self.N = N
        if N > 0 {
            for i in 0...N-1 {
                items.append(Item(value: i, id: i))
            }
        } else {
            throw QuickFind.Error.invalidN
        }
    }
    
    // P and Q should not be equal when calls union
    public func union(p: Int, q: Int) throws {
        guard p != q else {
            throw QuickFind.Error.unionPQShouldNotBeEqual
        }
        
        let pIndex = find(p)
        let qIndex = find(q)
        
        guard let pIndex = pIndex, let qIndex = qIndex else {
            throw QuickFind.Error.unionPQNotFound
        }
        
        for i in 0...items.count - 1 {
            if items[i].id == items[qIndex].id {
                items[i] = Item(value: items[i].value, id: items[pIndex].id)
            }
        }
    }
    
    public func connected(p: Int, q: Int) throws -> Bool {
        let pIndex = find(p)
        let qIndex = find(q)
        
        guard let pIndex = pIndex, let qIndex = qIndex else {
            throw QuickFind.Error.unionPQNotFound
        }
        
        return items[pIndex].id == items[qIndex].id
    }
    
    // Return the index of the array that contains P
    private func find(_ p: Int) -> Int? {
        for i in 0...items.count - 1 {
            if items[i].value == p {
                return i
            }
        }
        return nil
    }
}

public struct Item: Equatable {
    let value: Int
    let id: Int
    
    public init(value: Int, id: Int) {
        self.value = value
        self.id = id
    }
}


