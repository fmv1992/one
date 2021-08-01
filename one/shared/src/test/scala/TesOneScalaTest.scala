package fmv1992.one

import fmv1992.scala_cli_parser.cli.ArgumentCLI

class TestOne extends org.scalatest.funsuite.AnyFunSuite {
  test("Test `core`.") {
    val invalidInput01 = 0 to 10 map (_.toString)
    assertThrows[RuntimeException] {
      OneImpl.core(invalidInput01)
    }
    val invalidInput02 = Iterable()
    assertThrows[RuntimeException] {
      OneImpl.core(invalidInput02)
    }
    def validInput = Iterable("single line")
    assert(validInput === OneImpl.core(validInput))
  }

  // We should not execute this test because it relies on stdin.
  ignore("Test `testableMain`.") {
    OneImpl.testableMain(Set.empty: Set[ArgumentCLI])
  }
}
