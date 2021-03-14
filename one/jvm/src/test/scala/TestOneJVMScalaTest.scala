package fmv1992.one

class TestOneJVMScalaTest extends org.scalatest.funsuite.AnyFunSuite {
  test("Easiest test.") {
    val invalidInput01 = 0 to 10 map (_.toString)
    assertThrows[RuntimeException] {
      OneJVM.InnerCLIConfigTestableMain.core(invalidInput01)
    }
    val invalidInput02 = Iterable()
    assertThrows[RuntimeException] {
      OneJVM.InnerCLIConfigTestableMain.core(invalidInput02)
    }
    def validInput = Iterable("single line")
    assert(validInput === OneJVM.InnerCLIConfigTestableMain.core(validInput))
  }
}
