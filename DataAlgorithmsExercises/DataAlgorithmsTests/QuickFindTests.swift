//
//  QuickFindTests.swift
//  DataAlgorithmsTests
//
//  Created by anne.freitas on 15/02/23.
//

import DataAlgorithms
import XCTest

class QuickFindTests: XCTestCase {
    func test_init_createsItemsFrom0ToN() throws {
        let uf = try QuickFind(N: 10)
        XCTAssertEqual(
            uf.items,
            [
                Item(value: 0, id: 0),
                Item(value: 1, id: 1),
                Item(value: 2, id: 2),
                Item(value: 3, id: 3),
                Item(value: 4, id: 4),
                Item(value: 5, id: 5),
                Item(value: 6, id: 6),
                Item(value: 7, id: 7),
                Item(value: 8, id: 8),
                Item(value: 9, id: 9)
            ]
        )
    }
    
    func test_init_withInvalidN_shouldThrowErrors() throws {
        XCTAssertThrowsError(try QuickFind(N: 0)) { error in
            XCTAssertEqual(error as? QuickFind.Error, .invalidN)
        }
        
        XCTAssertThrowsError(try QuickFind(N: -1)) { error in
            XCTAssertEqual(error as? QuickFind.Error, .invalidN)
        }
    }
    
    func test_union_groupsTwoArrays_withPAndQValues() throws {
        let uf = try QuickFind(N: 10)
        
        try uf.union(p: 0, q: 1)
        XCTAssertEqual(
            uf.items,
            [
                Item(value: 0, id: 0),
                Item(value: 1, id: 0),
                Item(value: 2, id: 2),
                Item(value: 3, id: 3),
                Item(value: 4, id: 4),
                Item(value: 5, id: 5),
                Item(value: 6, id: 6),
                Item(value: 7, id: 7),
                Item(value: 8, id: 8),
                Item(value: 9, id: 9)
            ]
        )
        
        // Indirect union (0 and 9 now should be on the same group)
        try uf.union(p: 1, q: 9)
        XCTAssertEqual(
            uf.items,
            [
                Item(value: 0, id: 0),
                Item(value: 1, id: 0),
                Item(value: 2, id: 2),
                Item(value: 3, id: 3),
                Item(value: 4, id: 4),
                Item(value: 5, id: 5),
                Item(value: 6, id: 6),
                Item(value: 7, id: 7),
                Item(value: 8, id: 8),
                Item(value: 9, id: 0)
            ]
        )
        
        try uf.union(p: 3, q: 8)
        XCTAssertEqual(
            uf.items,
            [
                Item(value: 0, id: 0),
                Item(value: 1, id: 0),
                Item(value: 2, id: 2),
                Item(value: 3, id: 3),
                Item(value: 4, id: 4),
                Item(value: 5, id: 5),
                Item(value: 6, id: 6),
                Item(value: 7, id: 7),
                Item(value: 8, id: 3),
                Item(value: 9, id: 0)
            ]
        )
        
        // Union of 2 arrays
        try uf.union(p: 0, q: 8)
        XCTAssertEqual(
            uf.items,
            [
                Item(value: 0, id: 0),
                Item(value: 1, id: 0),
                Item(value: 2, id: 2),
                Item(value: 3, id: 0),
                Item(value: 4, id: 4),
                Item(value: 5, id: 5),
                Item(value: 6, id: 6),
                Item(value: 7, id: 7),
                Item(value: 8, id: 0),
                Item(value: 9, id: 0)
            ]
        )
    }
    
    func test_union_whenPQAreEqual_shouldThrowError() throws {
        let uf = try QuickFind(N: 10)
        
        XCTAssertThrowsError(try uf.union(p: 0, q: 0)) { error in
            XCTAssertEqual(error as? QuickFind.Error, .unionPQShouldNotBeEqual)
        }
    }
    
    func test_union_whenPQNotExists_shouldThrowError() throws {
        let uf = try QuickFind(N: 10)
        
        XCTAssertThrowsError(try uf.union(p: 100, q: 200)) { error in
            XCTAssertEqual(error as? QuickFind.Error, .unionPQNotFound)
        }
    }
    
    func test_connected_returnsTrueOnlyIfPQAreOnTheSameArray() throws {
        let uf = try QuickFind(N: 10)
        
        try uf.union(p: 0, q: 1)
        XCTAssertEqual(
            uf.items,
            [
                Item(value: 0, id: 0),
                Item(value: 1, id: 0),
                Item(value: 2, id: 2),
                Item(value: 3, id: 3),
                Item(value: 4, id: 4),
                Item(value: 5, id: 5),
                Item(value: 6, id: 6),
                Item(value: 7, id: 7),
                Item(value: 8, id: 8),
                Item(value: 9, id: 9)
            ]
        )
        
        XCTAssertTrue(try uf.connected(p: 0, q: 1))
        XCTAssertFalse(try uf.connected(p: 0, q: 2))
        
        try uf.union(p: 0, q: 2)
        XCTAssertEqual(
            uf.items,
            [
                Item(value: 0, id: 0),
                Item(value: 1, id: 0),
                Item(value: 2, id: 0),
                Item(value: 3, id: 3),
                Item(value: 4, id: 4),
                Item(value: 5, id: 5),
                Item(value: 6, id: 6),
                Item(value: 7, id: 7),
                Item(value: 8, id: 8),
                Item(value: 9, id: 9)
            ]
        )
        
        XCTAssertTrue(try uf.connected(p: 0, q: 2))
        XCTAssertTrue(try uf.connected(p: 1, q: 2))
        XCTAssertFalse(try uf.connected(p: 0, q: 3))
        
        // If P and Q are equal, then they are connected
        XCTAssertTrue(try uf.connected(p: 0, q: 0))
    }
}

