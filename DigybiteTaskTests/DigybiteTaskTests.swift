//
//  DigybiteTaskTests.swift
//  DigybiteTaskTests
//
//  Created by Adel Aref on 29/11/2023.
//

import XCTest
@testable import DigybiteTask

class DigybiteTaskTests: XCTestCase {

    let model = GameModel(id: 1,
                          name: "Spider Man",
                          backgroundImage: "",
                          description: "spiders movies",
                          website: "",
                          redditUrl: "reddit url",
                          genres: [],
                          isFavorite: false)

    var sut: GameViewModel! // system under test
    override func setUp() {
        sut = GameViewModel()
    }

    func testGameDetailsSuccess() {
        sut.games = [model]
        let firstGame = sut.games.first
        XCTAssert(firstGame?.name == "Spider Man", "game name not Spider Man")
    }
    
    func testGamesCountSuccess() {
        sut.games = [model]
        let count = sut.gameListCount
        XCTAssert(count == 1, "games count not equal 1")
    }
    
    func testGetGameByIndex() {
        sut.games = [model]
        sut.getGameByIndex(at: 0)
        XCTAssert(firstGame?.genres == [])
    }
    
    func testGetGameByIndex() {
        sut.games = [model]
        sut.getGameByIndex(at: 0)
        XCTAssert(firstGame?.genres == [])
    }
}
