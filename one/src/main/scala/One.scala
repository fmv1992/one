package fmv1992.one

import fmv1992.scala_cli_parser.CLIConfigTestableMain
import fmv1992.scala_cli_parser.Argument

import fmv1992.fmv1992_scala_utilities.util.S

import zio._

// Unfortunately I can't do that
// (<https://gitter.im/scala/scala?at=601db0719fa6765ef8fedc97>):
//
// ```
// object One extends App with CLIConfigTestableMain {
// ```
object One extends zio.App {

  object InnerCLIConfigTestableMain extends CLIConfigTestableMain {

    @inline override final val CLIConfigContents: String =
      S.putfile("src/main/resources/cli_config.conf")
    val programName: String = "one"
    val version: String = "0.0.1"

    // Members declared in fmv1992.scala_cli_parser.TestableMain
    def testableMain(
        args: Seq[Argument],
    ): Iterable[String] = {

      // Read all stdin lazily.
      val stdin =
        Stream.continually(scala.io.StdIn.readLine()).takeWhile(_ != null)

      core(stdin)
    }

    def testableMainZIO(
        args: Seq[Argument],
    ): ZIO[Any, Throwable, Iterable[String]] = {
      ???
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

    def coreZIO(
        input: Iterable[String],
    ): ZIO[Any, Throwable, Iterable[String]] = {
      ZIO.fromTry(scala.util.Try(core(input)))
    }

  }

  def readStdin(): zio.ZIO[zio.console.Console, Throwable, LazyList[String]] = {
    def go(
        acc: LazyList[String],
    ): zio.ZIO[zio.console.Console, Throwable, LazyList[String]] = {
      // zio.console.getStrLn.map(x => go(x #:: acc)).orElse(ZIO.succeed(acc))
      Console.err.println(acc.toList)
      zio.console.getStrLn
        .flatMap(newLine => go(acc.appended(newLine)))
        .orElse(ZIO.succeed(acc))
    }
    go().flatMap(x => zio.console.putStrLn(x.head)).exitCode
  }

}
