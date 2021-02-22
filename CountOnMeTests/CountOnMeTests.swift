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
        calculation.addNumbers(numbers: "5")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "2")
        // When :
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationResult, "7.0")
        XCTAssertTrue(calculation.expressionIsCorrect)
        XCTAssertTrue(calculation.haveEnoughElements)
        XCTAssertTrue(calculation.canAddOperator)
        XCTAssertTrue(calculation.expressionHasResult)
    }
    
    func testGivenThereIsAResult_WhenAddingNewNumber_ThenCalculationExpressionIsCleared() {
        // Given :
        calculation.addNumbers(numbers: "5")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "2")
        calculation.equals()
        // When :
        calculation.addNumbers(numbers: "12")
        // Then :
        XCTAssertEqual(calculation.calculationExpression, "12")
    }
    
    func testGivenFirstNumberIs3AndSecondNumberIs2_WhenSubstracting_ThenResultIs1() {
        // Given :
        calculation.addNumbers(numbers: "3")
        calculation.addOperator(symbol: "-")
        calculation.addNumbers(numbers: "2")
        // When :
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationResult, "1.0")
    }
    
    func testGivenFirstNumberIs3AndSecondNumberIs2_WhenMultiplicating_ThenResultIs6() {
        // Given :
        calculation.addNumbers(numbers: "3")
        calculation.addOperator(symbol: "×")
        calculation.addNumbers(numbers: "2")
        // When :
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationExpression, "3 × 2 = 6.0")
    }
    
    func testGivenFirstNumberIs6AndSecondNumberIs2_WhenDividing_ThenResultIs3() {
        // Given :
        calculation.addNumbers(numbers: "6")
        calculation.addOperator(symbol: "÷")
        calculation.addNumbers(numbers: "2")
        // When :
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationResult, "3.0")
    }
    
    func testGivenFirstElementIs4AndSecondElementIsPlus_WhenTypingPlusAgain_ThenCantAddExtraOperator() {
        // Given
        calculation.addNumbers(numbers: "4")
        calculation.addOperator(symbol: "+")
        // When
        calculation.addOperator(symbol: "+")
        // Then :
        XCTAssertFalse(calculation.canAddOperator)
    }
    
    func testGivenThereIsNotEnoughElements_WhenTypingEqualButton_ThenHaveEnoughElementsIsFalse() {
        // Given
        calculation.addNumbers(numbers: "4")
        calculation.addOperator(symbol: "+")
        // When
        calculation.equals()
        // Then :
        XCTAssertFalse(calculation.haveEnoughElements)
    }
    
    func testGivenAnOpeartorIsTheLastElementTyped_WhenTypingEqualButton_ThenOperationIsCorrectIsFalse() {
        // Given
        calculation.addNumbers(numbers: "4")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "2")
        calculation.addOperator(symbol: "+")
        // When
        calculation.equals()
        // Then :
        XCTAssertFalse(calculation.expressionIsCorrect)
    }
    
//    func testGivenThereIsAResultAlready_WhenTypingEqualButtonAgain_ThenExpressionIsCorrectIsFalse() {
//        // Given
//        calculation.calculationResult = "6 + 2 = 8.0"
//        // When
//        calculation.equals()
//        // Then
//        XCTAssert()
//    }
    // XCTAssert(operand = nil)
}
