/** How do we implement different implementation to the same interface?
  *
  * Lets use `zio.Fiber` as an example.
  *
  * `native` and `jvm` both define a `private[zio] trait FiberPlatformSpecific`
  * and `Fiber` resides on `shared`:
  *
  * ```
  * object Fiber extends FiberPlatformSpecific {
  * ```
  *
  * See
  * <https://github.com/zio/zio/blob/b30d5cf5ffb9fdf33ddeabedc17d9a67cdc73379/core/shared/src/main/scala/zio/Fiber.scala#L389>.
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
    // The order of the argument parsing here matters. `n` is optional, so it
    // is always set. Thus `empty` has to come before this option.
    args
      .find(_.name == "empty")
      .map(_ => { require(getInput().isEmpty); Seq.empty })
      .getOrElse(
        args
          .find(_.name == "n")
          .map(x => {
            val nInput = x.values(0).toInt
            require(nInput > 0)
            core(getInput(), nInput)
          })
          .get
      )

  }

  def core(input: Iterable[String], nInput: Int): Iterable[String] = {
    val showExtraLines = 9

    val lines = input.take(nInput).toList
    val wrongNoTrunc = input.drop(nInput).take(showExtraLines + nInput).toList
    val wrong = if (wrongNoTrunc.length == (showExtraLines + nInput)) {
      wrongNoTrunc.take(showExtraLines) :+ "⋯ ellided lines ⋯"
    } else { wrongNoTrunc }
    if (lines.length == nInput && wrong.isEmpty) {
      lines
    } else {
      throw new RuntimeException(
        s"Line count is at least '${lines.length + wrong.length}' and it should be '${nInput}'. Lines: \n"
          + (lines ++ wrong).mkString("\n")
      )
    }
  }

  // All that is left for each platform is to efficiently implement getting
  // input.
  def getInput(): Iterable[String]

}
