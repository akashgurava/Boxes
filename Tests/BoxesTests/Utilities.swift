//
//  File.swift
//
//
//  Created by Akash Gurava on 02/07/22.
//

import Foundation


@_transparent @discardableResult public func measureBlock(
    label: String? = nil,
    tests: Int = 1,
    printResults output: Bool = true,
    setup: @escaping () -> Void = { return },
    _ block: @escaping () -> Void
) -> Double {

    guard tests > 0 else { fatalError("Number of tests must be greater than 0") }

    var avgExecutionTime: CFAbsoluteTime = 0
    for _ in 1...tests {
        setup()
        let start = CFAbsoluteTimeGetCurrent()
        block()
        let end = CFAbsoluteTimeGetCurrent()
        avgExecutionTime += end - start
    }

    avgExecutionTime /= CFAbsoluteTime(tests)

    if output {
        let avgTimeStr = "\(avgExecutionTime)".replacingOccurrences(of: "e|E", with: " × 10^", options: .regularExpression, range: nil)

        if let label = label {
            print(label, "▿")
            print("\tExecution time: \(avgTimeStr)s")
            print("\tNumber of tests: \(tests)\n")
        } else {
            print("Execution time: \(avgTimeStr)s")
            print("Number of tests: \(tests)\n")
        }
    }

    return avgExecutionTime
}

public func randomString(_ length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
