package fmv1992.one

import fmv1992.scala_cli_parser.CLIConfigTestableMain
import fmv1992.scala_cli_parser.Argument

import fmv1992.fmv1992_scala_utilities.util.S

/** `One` implementation using Scala Native.
  *
  *  `zio` could be used together with Scala Native as in the `v0.1.x` series
  *  but then the output binary becomes big (~12 Mb).
  */
object OneImpl extends CLIConfigTestableMain with One {

  @inline override final val CLIConfigContents: String =
    S.putfile("shared/src/main/resources/cli_config.conf")
  val programName: String = "one"
  val version: String = "0.0.1"

  // Members declared in fmv1992.scala_cli_parser.TestableMain
  def testableMain(
      args: Seq[fmv1992.scala_cli_parser.Argument],
  ): Iterable[String] = {

    // Read all stdin lazily.
    val stdin =
      Stream.continually(scala.io.StdIn.readLine()).takeWhile(_ != null)

    core(stdin)
  }

  def core(input: Iterable[String]): Iterable[String] = {
    val showExtraLines = 9
    val right = input.take(1).toList
    val wrongNoTrunc = input.tail.take(showExtraLines + 1).toList

    // Add elided lines in case there are many lines.
    val wrong = if (wrongNoTrunc.length == (showExtraLines + 1)) {
      wrongNoTrunc.take(showExtraLines) :+ "⋯ elided lines ⋯"
    } else { wrongNoTrunc }

    if (right.length != 1) {
      throw new RuntimeException(
        s"Lines length is at least '${right.length}' and it should be '1'.",
      )
    }
    if (wrong.length != 0) {
      throw new RuntimeException(
        s"Line count is at least '${right.length + wrong.length}' and it should be '1'. Lines: \n"
          + (right ++ wrong).mkString("\n"),
      )
    } else {
      right
    }
  }
}
