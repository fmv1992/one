package fmv1992.one

// 🐛: ???: These are duplicates.
class TestOneJVMScalaTest extends org.scalatest.funsuite.AnyFunSuite {
  test("Easiest test.") {
    val invalidInput01 = 0 to 10 map (_.toString)
    assertThrows[RuntimeException] {
      OneImpl.InnerCLIConfigTestableMain.core(invalidInput01)
    }
    val invalidInput02 = Iterable()
    assertThrows[RuntimeException] {
      OneImpl.InnerCLIConfigTestableMain.core(invalidInput02)
    }
    def validInput = Iterable("single line")
    assert(validInput === OneImpl.InnerCLIConfigTestableMain.core(validInput))
  }
}
