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
    
    // MARK: - Simple calculations tests
    
    // Testing addition
    func testGivenFirstNumberIs5AndSecondNumberIs2_WhenAdditioning_ThenResultIs7() {
        // Given :
        calculation.addNumbers(numbers: "5")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "2")
        // When :
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationResult, "7.0") // raw value
        XCTAssertEqual(calculation.calculationExpression, "5 + 2 = 7") // the way it is displayed for users
    }
    
    // Testing substraction
    func testGivenFirstNumberIs3AndSecondNumberIs2_WhenSubstracting_ThenResultIs1() {
        // Given :
        calculation.addNumbers(numbers: "3")
        calculation.addOperator(symbol: "-")
        calculation.addNumbers(numbers: "2")
        // When :
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationResult, "1.0")
        XCTAssertEqual(calculation.calculationExpression, "3 - 2 = 1")
    }
    
    // Testing multiplication
    func testGivenFirstNumberIs3AndSecondNumberIs2_WhenMultiplicating_ThenResultIs6() {
        // Given :
        calculation.addNumbers(numbers: "3")
        calculation.addOperator(symbol: "×")
        calculation.addNumbers(numbers: "2")
        // When :
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationResult, "6.0")
        XCTAssertEqual(calculation.calculationExpression, "3 × 2 = 6")
    }
    
    // Testing division
    func testGivenFirstNumberIs6AndSecondNumberIs2_WhenDividing_ThenResultIs3() {
        // Given :
        calculation.addNumbers(numbers: "6")
        calculation.addOperator(symbol: "÷")
        calculation.addNumbers(numbers: "2")
        // When :
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationResult, "3.0")
        XCTAssertEqual(calculation.calculationExpression, "6 ÷ 2 = 3")
    }
    
    // Ensures that operations are calculated based on their mathematical priority order
    func testGivenCalculationHasPriorityOperators_WhenTypingEquals_ThenCalculationIsExecutedByPriorityOrder() {
        // Given
        calculation.addNumbers(numbers: "4")
        calculation.addOperator(symbol: "÷")
        calculation.addNumbers(numbers: "2")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "2")
        calculation.addOperator(symbol: "×")
        calculation.addNumbers(numbers: "3")
        // When
        calculation.equals()
        // Then
        XCTAssertEqual(calculation.calculationResult, "8.0")
        XCTAssertEqual(calculation.calculationExpression, "4 ÷ 2 + 2 × 3 = 8")
    }
    
    // MARK: - calculationExpression cleaning before new calculation tests
    
    // This test makes sure that after a calculation, if the user types a number again, the old calculation is cleared and only the new element shows.
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
    
    // This test makes sure that after a calculation, if the user types a symbol again, the old calculation is cleared and only the new element shows.
    func testGivenThereIsAResult_WhenAddingNewOperator_ThenCalculationExpressionIsCleared() {
        // Given :
        calculation.addNumbers(numbers: "5")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "2")
        calculation.equals()
        // When :
        calculation.addOperator(symbol: "+")
        // Then :
        XCTAssertEqual(calculation.calculationExpression, " + ")
    }
    
    // MARK: - Testing errors
    
    // Ensures that typing "+" twice in a row gets the user an error.
    func testGivenFirstElementIs4AndSecondElementIsPlus_WhenTypingPlusAgain_ThenErrorShows() {
        // Given
        calculation.addNumbers(numbers: "4")
        calculation.addOperator(symbol: "+")
        // When
        calculation.addOperator(symbol: "+")
        // Then :
        XCTAssertEqual(calculation.calculationExpression, "= invalid op.")
    }
    
    // Ensures that an incomplete operation shows "= missing elem." on calculationExpression when "=" is typed.
    func testGivenThereIsNotEnoughElements_WhenTypingEqualButton_ThenExpressionShowsError() {
        // Given
        calculation.addNumbers(numbers: "4")
        calculation.addOperator(symbol: "+")
        // When
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationExpression, "= missing elem.")
    }
    
    // Ensures that an operation ending with a symbol shows "= incorrect last elem." on calculationExpression when "=" is typed.
    func testGivenAnOpeartorIsTheLastElementTyped_WhenTypingEqualButton_ThenErrorShows() {
        // Given
        calculation.addNumbers(numbers: "4")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "2")
        calculation.addOperator(symbol: "+")
        // When
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationExpression, "= incorrect last elem.")
    }
    
    // Ensures that an operation starting with an invalid symbol shows "= incorrect first elem." on calculationExpression when "=" is typed.
    func testGivenDivisionOperatorIsTheFirstElementTyped_WhenTypingEqualButton_ThenErrorShows() {
        // Given
        calculation.addOperator(symbol: "÷")
        calculation.addNumbers(numbers: "4")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "2")
        // When
        calculation.equals()
        // Then :
        XCTAssertEqual(calculation.calculationExpression, "= incorrect first elem.")
    }
    
    // Ensures that an error shows when dividing by zero
    func testGivenOperationIsFourDividedByZero_WhenTypingEqual_ThenErrorNotApplicable() {
        // Given:
        calculation.calculationExpression = "5 ÷ 0"
        // When:
        calculation.equals()
        // Then:
        XCTAssertEqual(calculation.calculationExpression, "= div. by zero")
    }
    
    // MARK: - Testing CountOnMe specificities
    
    // Ensures that CountOnMe handles decimal numbers
    func testGivenOperationIsFiveDividedByTwo_WhenTypingEqual_ThenResultShownWillHaveDecimal() {
        // Given:
        calculation.addNumbers(numbers: "5")
        calculation.addOperator(symbol: "÷")
        calculation.addNumbers(numbers: "2")
        // When:
        calculation.equals()
        // Then:
        XCTAssertEqual(calculation.calculationResult, "2.5")
        XCTAssertEqual(calculation.calculationExpression, "5 ÷ 2 = 2.5")
    }
    
    // Ensures that operations starting with "-" are valid
    func testGivenOperationStartsWithMinus_WhenTypingEqual_ThenMinusIsAssociatedToFirstNumber() {
        // Given
        calculation.addOperator(symbol: "-")
        calculation.addNumbers(numbers: "3")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "3")
        // When
        calculation.equals()
        // Then
        XCTAssertEqual(calculation.calculationResult, "0.0")
        XCTAssertEqual(calculation.calculationExpression, " - 3 + 3 = 0")
    }
    
    // Ensures that operations starting with "+" are valid
    func testGivenOperationStartsWithPlus_WhenTypingEqual_ThenPlusIsAssociatedToFirstNumber() {
        // Given
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "3")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "3")
        // When
        calculation.equals()
        // Then
        XCTAssertEqual(calculation.calculationResult, "6.0")
        XCTAssertEqual(calculation.calculationExpression, " + 3 + 3 = 6")
    }
    
    // Considering that a result is already displayed, if the user types the "=" symbol again, only final result remains on calculationExpression.
    func testGivenThereIsAResult_WhenTypingEqualAgain_ThenOnlyFinalResultStays() {
        // Given
        calculation.addNumbers(numbers: "5")
        calculation.addOperator(symbol: "+")
        calculation.addNumbers(numbers: "2")
        calculation.equals()
        // When
        calculation.equals()
        // Then
        XCTAssertEqual(calculation.calculationExpression, " = 7")
    }
}
