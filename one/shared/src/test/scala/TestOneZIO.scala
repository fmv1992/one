// package fmv1992.one
//
// import zio.ZIO
//
// object TestOneZIO extends zio.test.DefaultRunnableSpec {
//   def spec = suite("TestOneZIO")(
//     // suite("`readStdin`.")(
//     //   testM("`readStdin` basics 01.") {
//     //     for {
//     //       _ <- zio.test.environment.TestConsole.feedLines("x", "y", "z")
//     //       input <- OneZIOImpl.readStdin()
//     //     } yield (zio.test.assert(input.toVector)(
//     //       zio.test.Assertion.equalTo(Vector("x", "y", "z")),
//     //     ))
//     //   },
//     //   testM("`readStdin` feed infinite stdin (assery lazy).") {
//     //     ???
//     //   } @@ zio.test.TestAspect.ignore,
//     // ),
//     suite("`core`.")(
//       testM("`core` basics 01.") {
//         zio.test.assertM(
//           OneZIOImpl.InnerCLIConfigTestableMain.coreZIO(List("x")),
//         )(
//           zio.test.Assertion.equalTo(List("x")),
//         )
//       },
//       testM("`core` basics 02.") {
//         for {
//           exit <- OneZIOImpl.InnerCLIConfigTestableMain
//             .coreZIO(List("x", "y"))
//             .run
//         } yield zio.test.assert(
//           exit,
//         )(
//           zio.test.Assertion.fails(zio.test.Assertion.anything),
//         )
//       },
//     ),
//     suite("`run`.")(
//       testM("`run`: failure case.") {
//         for {
//           _ <- zio.test.environment.TestConsole.feedLines("x", "y", "z")
//           exitCode <- OneZIOImpl.run(List.empty)
//           output <- zio.test.environment.TestConsole.output
//         } yield (zio.test.assert(output)(
//           zio.test.Assertion.equalTo(Vector.empty),
//         ) &&
//           zio.test.assert(exitCode.code)(
//             zio.test.Assertion.not(zio.test.Assertion.equalTo(0)),
//           ))
//       },
//       testM("`run`: success case.") {
//         for {
//           _ <- zio.test.environment.TestConsole.feedLines("x")
//           exitCode <- OneZIOImpl.run(List.empty)
//           output <- zio.test.environment.TestConsole.output
//         } yield (zio.test.assert(output)(
//           zio.test.Assertion.equalTo(Vector("x" + "\n")),
//         ) &&
//           zio.test.assert(exitCode.code)(zio.test.Assertion.equalTo(0)))
//       },
//     ),
//   )
// }
