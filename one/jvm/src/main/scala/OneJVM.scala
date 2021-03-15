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
object OneImpl extends zio.App with One {

  object InnerCLIConfigTestableMain extends CLIConfigTestableMain {

    @inline override final val CLIConfigContents: String =
      S.putfile("shared/src/main/resources/cli_config.conf")
    val programName: String = "one"
    val version: String = "0.1.0"

    // Members declared in fmv1992.scala_cli_parser.TestableMain
    def testableMain(
        args: Seq[Argument],
    ): Iterable[String] = {

      // Read all stdin lazily.
      val stdin =
        Stream.continually(scala.io.StdIn.readLine()).takeWhile(_ != null)

      zio.Runtime.default.unsafeRun(
        zio.stream.ZStream
          .repeatEffect(zio.console.getStrLn)
          .fold(LazyList.empty: LazyList[String])((l, s) => l.appended(s))
          .flatMap(l => InnerCLIConfigTestableMain.coreZIO(l)),
      )
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

  def run(args: List[String]): URIO[ZEnv, ExitCode] = {
    zio.stream.ZStream
      .repeatEffect(zio.console.getStrLn.option)
      .takeWhile(_.isDefined)
      .map(
        _.getOrElse(throw new Exception("This exception should never happen.")),
      )
      .toIterator
      .use(ie => {
        InnerCLIConfigTestableMain
          .coreZIO(
            ie.map(
              _.getOrElse(
                throw new Exception("This exception should never happen."),
              ),
            ).to(LazyList),
          )
      })
      .flatMap(l =>
        l.foldLeft(URIO.succeed(()): zio.URIO[zio.console.Console, Unit])(
          (z, line) => z.zipLeft(zio.console.putStrLn(line)),
        ),
      )
      .exitCode
  }

}
