package fmv1992.one

import zio.ZIO

object TestOneZIO extends zio.test.DefaultRunnableSpec {
  def spec = suite("TestOneZIO")(
    suite("`core`.")(
      testM("`core` basics 01.") {
        zio.test.assertM(One.InnerCLIConfigTestableMain.coreZIO(List("x")))(
          zio.test.Assertion.equalTo(List("x")),
        )
      },
      testM("`core` basics 02.") {
        for {
          exit <- One.InnerCLIConfigTestableMain.coreZIO(List("x", "y")).run
        } yield zio.test.assert(
          exit,
        )(
          zio.test.Assertion.fails(zio.test.Assertion.anything),
        )
      },
    ),
    suite("`run`.")(
      testM("`run` basics 01.") {
        for {
          _ <- zio.test.environment.TestConsole.feedLines("x")
          exitCode <- One.run(List.empty)
          output <- zio.test.environment.TestConsole.output
        } yield (zio.test.assert(output)(
          zio.test.Assertion.equalTo(Vector("x").map(_ + '\n')),
        ) &&
          zio.test.assert(exitCode.code)(zio.test.Assertion.equalTo(0)))
      },
    ),
  )
}
