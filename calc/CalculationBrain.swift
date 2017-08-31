//
//  CalculationBrain.swift
//  calc
//
//  Created by maksim_p on 18.07.17.
//  Copyright © 2017 maksim_p. All rights reserved.
//

import Foundation

struct CalculationBrain {
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private var accumulator: Double?
    private var pendingBinaryOperation : PendingBinaryOperation?
    private var operations : Dictionary<String,Operation> = ["%" : Operation.unaryOperation({$0/100}),
                                                             "AC" : Operation.constant(0),
                                                             "±" : Operation.unaryOperation({ $0 == 0 ? 0 : -$0 }),
                                                             "x" : Operation.binaryOperation({$0 * $1}),
                                                             "÷" : Operation.binaryOperation({$0 / $1}),
                                                             "-" : Operation.binaryOperation({$0 - $1}),
                                                             "+" : Operation.binaryOperation({$0 + $1}),
                                                             "=": Operation.equals]
    
    var result : Double? {
        get {
            return accumulator
        }
    }
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                break
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private struct PendingBinaryOperation {
        let function : (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
}
