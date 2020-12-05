package fmv1992.one

class TestOne extends org.scalatest.funsuite.AnyFunSuite {
  test("Easiest test.") {
    val invalidInput01 = 0 to 10 map (_.toString)
    assertThrows[RuntimeException] {
      One.core(invalidInput01)
    }
    val invalidInput02 = Iterable()
    assertThrows[RuntimeException] {
      One.core(invalidInput02)
    }
    def validInput = Iterable("single line")
    assert(validInput === One.core(validInput))
  }
}
