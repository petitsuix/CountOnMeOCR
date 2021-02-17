//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Richardier on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CountOnMeTests: XCTestCase {
    
    var calculation: Calculation!
    
    override func setUp() {
        calculation = Calculation()
    }
    
    override func tearDown() {
        calculation = nil
    }
    
    func testGivenFirstNumberIs5AndSecondNumberIs2_WhenAdditioning_ThenResultIs7() {
        // Given :
        let firstNumber = 5
        let secondNumber = 2
        // When :
        let result = calculation?.addition(firstNumber: firstNumber, secondNumber: secondNumber)
        // Then :
        XCTAssertEqual(result, "7")
    }
    
    func testGivenFirstNumberIs3AndSecondNumberIs2_WhenSubstracting_ThenResultIs1() {
        // Given :
        let firstNumber = 3
        let secondNumber = 2
        // When :
        let result = calculation?.substraction(firstNumber: firstNumber, secondNumber: secondNumber)
        // Then :
        XCTAssertEqual(result, "1")
    }
    
    func testGivenFirstNumberIs3AndSecondNumberIs2_WhenMultiplicating_ThenResultIs6() {
        // Given :
        let firstNumber = 3
        let secondNumber = 2
        // When :
        let result = calculation?.multiplication(firstNumber: firstNumber, secondNumber: secondNumber)
        // Then :
        XCTAssertEqual(result, "6")
    }
    
    func testGivenFirstNumberIs6AndSecondNumberIs2_WhenDividing_ThenResultIs3() {
        // Given :
        let firstNumber = 6
        let secondNumber = 2
        // When :
        let result = calculation?.division(firstNumber: firstNumber, secondNumber: secondNumber)
        // Then :
        XCTAssertEqual(result, "3")
    }
    
}
