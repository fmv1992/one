package fmv1992.one

import fmv1992.scala_cli_parser.CLIConfigTestableMain
import fmv1992.scala_cli_parser.Argument

import fmv1992.fmv1992_scala_utilities.util.S
import fmv1992.fmv1992_scala_utilities.util.Reader

object One extends CLIConfigTestableMain {

  @inline override final val CLIConfigPath: String =
    S.putabspath("src/main/resources/cli_config.conf")
  val programName: String = "one"
  val version: String = "0.0.1"

  // Members declared in fmv1992.scala_cli_parser.TestableMain
  def testableMain(
      args: Seq[fmv1992.scala_cli_parser.Argument]
  ): Iterable[String] = {
    val stdin = Stream.continually(scala.io.StdIn.readLine).takeWhile(_ != null)
    core(stdin)
  }

  def core(input: Iterable[String]): Iterable[String] = {
    val right = input.take(1).toList
    val wrong = input.tail.take(9).toList
    if (right.length != 1) {
      throw new RuntimeException(
        s"Lines length is '${right.length}' and it should be '1'."
      )
    }
    if (wrong.length != 0) {
      throw new RuntimeException(
        s"Lines length is '${right.length + wrong.length}' and it should be one. Lines: \n"
          + (right ++ wrong).mkString("\n")
      )
    } else {
      right
    }
  }
}
