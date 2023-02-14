//
//  UnionFindTests.swift
//  DataAlgorithmsExercisesTests
//
//  Created by anne.freitas on 14/02/23.
//

import DataAlgorithms
import XCTest

class UnionFindTests: XCTestCase {
    func test_init_createsItemsFrom0ToN() throws {
        let uf = try UnionFind(N: 10)
        XCTAssertEqual(uf.items, [[0], [1], [2], [3], [4], [5], [6] ,[7] ,[8], [9]])
    }
    
    func test_init_withInvalidN_shouldThrowErrors() throws {
        XCTAssertThrowsError(try UnionFind(N: 0)) { error in
            XCTAssertEqual(error as? UnionFind.Error, .invalidN)
        }
        
        XCTAssertThrowsError(try UnionFind(N: -1)) { error in
            XCTAssertEqual(error as? UnionFind.Error, .invalidN)
        }
    }
    
    func test_union_groupsTwoArrays_withPAndQValues() throws {
        let uf = try UnionFind(N: 10)
        XCTAssertEqual(uf.items, [[0], [1], [2], [3], [4], [5], [6] ,[7] ,[8], [9]])
        
        try uf.union(p: 0, q: 1)
        XCTAssertEqual(uf.items, [[0, 1], [2], [3], [4], [5], [6] ,[7] ,[8], [9]])
        
        // Indirect union (0 and 9 now should be on the same group)
        try uf.union(p: 1, q: 9)
        XCTAssertEqual(uf.items, [[0, 1, 9], [2], [3], [4], [5], [6] ,[7] ,[8]])
        
        try uf.union(p: 3, q: 8)
        XCTAssertEqual(uf.items, [[0, 1, 9], [2], [3, 8], [4], [5], [6] ,[7]])
        
        // Union of 2 arrays
        try uf.union(p: 0, q: 8)
        XCTAssertEqual(uf.items, [[0, 1, 9, 3, 8], [2], [4], [5], [6] ,[7]])
    }
    
    func test_union_whenPQAreEqual_shouldThrowError() throws {
        let uf = try UnionFind(N: 10)
        
        XCTAssertThrowsError(try uf.union(p: 0, q: 0)) { error in
            XCTAssertEqual(error as? UnionFind.Error, .unionPQShouldNotBeEqual)
        }
    }
    
    func test_union_whenPQNotExists_shouldThrowError() throws {
        let uf = try UnionFind(N: 10)
        
        XCTAssertThrowsError(try uf.union(p: 100, q: 200)) { error in
            XCTAssertEqual(error as? UnionFind.Error, .unionPQNotFound)
        }
    }
    
    func test_connected_returnsTrueOnlyIfPQAreOnTheSameArray() throws {
        let uf = try UnionFind(N: 10)
        XCTAssertEqual(uf.items, [[0], [1], [2], [3], [4], [5], [6] ,[7] ,[8], [9]])
        
        try uf.union(p: 0, q: 1)
        XCTAssertEqual(uf.items, [[0, 1], [2], [3], [4], [5], [6] ,[7] ,[8], [9]])
        
        XCTAssertTrue(uf.connected(p: 0, q: 1))
        XCTAssertFalse(uf.connected(p: 0, q: 2))
        
        try uf.union(p: 0, q: 2)
        XCTAssertEqual(uf.items, [[0, 1, 2], [3], [4], [5], [6] ,[7] ,[8], [9]])
        
        XCTAssertTrue(uf.connected(p: 0, q: 2))
        XCTAssertTrue(uf.connected(p: 1, q: 2))
        XCTAssertFalse(uf.connected(p: 0, q: 3))
        
        // If P and Q are equal, then they are connected
        XCTAssertTrue(uf.connected(p: 0, q: 0))
    }
}
