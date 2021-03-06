// RUN: %target-run-simple-swift
// REQUIRES: executable_test
// REQUIRES: OS=macosx
// REQUIRES: objc_interop

// FIXME: This test fails occassionally in CI with invalid json.
// REQUIRES: disabled

import StdlibUnittest
import Foundation
import SwiftSyntax

func getInput(_ file: String) -> URL {
  var result = URL(fileURLWithPath: #file)
  result.deleteLastPathComponent()
  result.appendPathComponent("Inputs")
  result.appendPathComponent(file)
  return result
}

var VisitorTests = TestSuite("SyntaxVisitor")

VisitorTests.test("Basic") {
  class FuncCounter: SyntaxVisitor {
    var funcCount = 0
    override func visit(_ node: FunctionDeclSyntax) {
      funcCount += 1
      super.visit(node)
    }
  }
  expectDoesNotThrow({
    let parsed = try SourceFileSyntax.parse(getInput("visitor.swift"))
    let counter = FuncCounter()
    let hashBefore = parsed.hashValue
    counter.visit(parsed)
    expectEqual(counter.funcCount, 3)
    expectEqual(hashBefore, parsed.hashValue)
  })
}

runAllTests()
