package fmv1992.one

import fmv1992.scala_cli_parser.cli.ArgumentCLI

class TestOne extends org.scalatest.funsuite.AnyFunSuite {
  test("Test `core`.") {
    val input01 = 0 to 10 map (_.toString)
    assertThrows[RuntimeException] { OneImpl.core(input01, 1) }
    assertThrows[RuntimeException] { OneImpl.core(input01, 0) }
    assertThrows[RuntimeException] { OneImpl.core(input01, 12) }
    assert(input01 === OneImpl.core(input01, 11))

    val input02 = Iterable()
    assertThrows[RuntimeException] { OneImpl.core(input02, 1) }
    assertThrows[RuntimeException] { OneImpl.core(input02, 100) }
    assert(input02 === OneImpl.core(input02, 0))

    def input03 = Iterable("single line")
    assertThrows[RuntimeException] { OneImpl.core(input03, 0) }
    assertThrows[RuntimeException] { OneImpl.core(input03, 2) }
    assertThrows[RuntimeException] { OneImpl.core(input03, -1) }
    assertThrows[RuntimeException] { OneImpl.core(input03, 10000) }
    assert(input03 === OneImpl.core(input03, 1))
  }

  // We should not execute this test because it relies on stdin.
  ignore("Test `testableMain`.") {
    OneImpl.testableMain(Set.empty: Set[ArgumentCLI])
  }
}
