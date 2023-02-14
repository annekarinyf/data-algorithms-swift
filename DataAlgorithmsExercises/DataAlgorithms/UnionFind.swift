//
//  UnionFind.swift
//  DataAlgorithmsExercises
//
//  Created by anne.freitas on 14/02/23.
//

import Foundation

public final class UnionFind {
    private let N: Int
    public private (set) var items = [[Int]]()
    
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
                items.append([i])
            }
        } else {
            throw UnionFind.Error.invalidN
        }
    }
    
    // P and Q should not be equal when calls union
    public func union(p: Int, q: Int) throws {
        guard p != q else {
            throw UnionFind.Error.unionPQShouldNotBeEqual
        }
        
        let pIndex = find(p)
        let qIndex = find(q)
        
        guard let pIndex = pIndex, let qIndex = qIndex else {
            throw UnionFind.Error.unionPQNotFound
        }
        
        items[pIndex].append(contentsOf: items[qIndex])
        items.remove(at: qIndex)
    }
    
    public func connected(p: Int, q: Int) -> Bool {
        let pIndex = find(p)
        let qIndex = find(q)
        
        return pIndex == qIndex
    }
    
    // Return the index of the array that contains P
    private func find(_ p: Int) -> Int? {
        for i in 0...items.count - 1 {
            if items[i].contains(p) {
                return i
            }
        }
        return nil
    }
}

