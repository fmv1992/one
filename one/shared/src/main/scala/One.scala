/**  How do we implement different implementation to the same interface?
  *
  *  Lets use `zio.Fiber` as an example.
  *
  *  `native` and `jvm` both define a `private[zio] trait
  *  FiberPlatformSpecific` and `Fiber` resides on `shared`:
  *
  *  ```
  *  object Fiber extends FiberPlatformSpecific {
  *  ```
  *
  *  See
  *  <https://github.com/zio/zio/blob/b30d5cf5ffb9fdf33ddeabedc17d9a67cdc73379/core/shared/src/main/scala/zio/Fiber.scala#L389>.
  */

package fmv1992.one

import fmv1992.fmv1992_scala_utilities.util.S

import fmv1992.scala_cli_parser.util.MainTestableConfBased
import fmv1992.scala_cli_parser.cli.ArgumentCLI

trait One extends MainTestableConfBased {

  @inline override final protected[this] val CLIConfigContents: String =
    S.putfile("shared/src/main/resources/cli_config.conf")

  val programName: String = "one"
  val version: String = "v0.2.0-dev"

  def testableMain(args: Set[ArgumentCLI]): Iterable[String] = {
    if (!args.isEmpty) {
      throw new RuntimeException(
        s"`one` does not take any args at this point. Got '${args}'.",
      )
    } else {
      core(getInput())
    }
  }

  def core(input: Iterable[String]): Iterable[String] = {
    val showExtraLines = 9
    val right = input.take(1).toList
    val wrongNoTrunc = input.tail.take(showExtraLines + 1).toList
    val wrong = if (wrongNoTrunc.length == (showExtraLines + 1)) {
      wrongNoTrunc.take(showExtraLines) :+ "⋯ ellided lines ⋯"
    } else { wrongNoTrunc }

    if (right.length != 1) {
      throw new RuntimeException(
        s"Lines length is at least '${right.length}' and it should be '1'.",
      )
    }
    if (wrong.length != 0) {
      throw new RuntimeException(
        s"Line count is at least '${right.length + wrong.length}' and it should be one. Lines: \n"
          + (right ++ wrong).mkString("\n"),
      )
    } else {
      right
    }
  }

  // All that is left for each platform is to efficiently implement getting
  // input.
  def getInput(): Iterable[String]

}
