package fmv1992.one

// 🐛: ???: These are duplicates.
class TestOneNativeScalaTest extends org.scalatest.funsuite.AnyFunSuite {
  test("Easiest test.") {
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
}
