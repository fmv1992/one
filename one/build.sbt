// give the user a nice default project!

lazy val scala213 = "2.13.4"
lazy val zioVersion = "1.0.4-2"

Global / onChangedBuildSource := ReloadOnSourceChanges

val versionsJVM = Seq(scala213)
val versionsNative = Seq(scala213)

inThisBuild(
  List(
    scalaVersion := scala213,
    scalafixDependencies += "com.github.liancheng" %% "organize-imports" % "0.4.3",
    scalafixScalaBinaryVersion := CrossVersion.binaryScalaVersion(
      scalaVersion.value
    ),
    // https://index.scala-lang.org/ohze/scala-rewrites/scala-rewrites/0.1.10-sd?target=_2.13
    semanticdbEnabled := true,
    semanticdbOptions += "-P:semanticdb:synthetics:on", // make sure to add this
    semanticdbVersion := scalafixSemanticdb.revision,
    scalafixScalaBinaryVersion := CrossVersion.binaryScalaVersion(
      scalaVersion.value
    )
  )
  // This should include this change:
  // ???: `git diff 9e27b70e9ccf2a9cfc6d2fb5dace9e04c62f41bd..cc67d0040b4684b4dcb454fd63da4084ef00e587`
)

lazy val commonSettings = Seq(
  resolvers += Resolver.mavenLocal,
  Compile / scalacOptions ++= {
    CrossVersion.partialVersion(scalaVersion.value) match {
      // ???: -Ywarn-unused-import, -Xlint:unused
      case Some((2, n)) if n == 11 => List("-Ywarn-unused-import")
      case Some((2, n)) if n == 12 => List("-Ywarn-unused")
      case Some((2, n)) if n == 13 => List("-Ywarn-unused")
    }
  },
  assemblyMergeStrategy in assembly := {
    case PathList("META-INF", xs @ _*) => MergeStrategy.discard
    case x                             => MergeStrategy.first
  }
)

lazy val commonDependencies = Seq(
  libraryDependencies ++= {
    CrossVersion.partialVersion(scalaVersion.value) match {
      case Some((2, n)) if n == 13 =>
        List(
          "org.scala-lang" %% "scala-rewrites" % "0.1.3",
          "org.scalatest" %%% "scalatest" % "3.2.4-M1" % Test,
          "io.github.fmv1992" %%% "scala_cli_parser" % "0.4.1-dev",
          "dev.zio" %%% "zio" % zioVersion,
          "dev.zio" %%% "zio-streams" % zioVersion,
          "dev.zio" %%% "zio-test" % zioVersion % "test",
          "dev.zio" %% "zio-test-sbt" % zioVersion % "test"
        )
      case _ => Nil
    }
  },
  mainClass in Compile := Some("fmv1992.one.One")
)

lazy val commonSettingsAndDependencies = commonSettings ++ commonDependencies

lazy val scalaNativeSettings = Seq(
  crossScalaVersions := versionsNative,
  scalaVersion := scala213, // allows to compile if scalaVersion set not 2.11
  nativeLinkStubs := true,
  nativeLinkStubs in runMain := true,
  nativeLinkStubs in Test := true,
  test in nativeLink := false,
  sources in (Compile, doc) := Seq.empty,
  artifactPath in (Compile, nativeLink) := {
    file("target/one")
  },
  mainClass in Compile := Some("fmv1992.one.OneImpl")
)

lazy val crossProj: sbtcrossproject.CrossProject =
  crossProject(JVMPlatform, NativePlatform)
    .crossType(CrossType.Full)
    .in(file("."))
    .settings(
      name := "one"
    )
    .settings(commonSettingsAndDependencies)
    .jvmSettings(
      crossScalaVersions := versionsJVM,
      mainClass in assembly := Some("fmv1992.one.OneImpl")
    )
    .nativeSettings(
      scalaNativeSettings
    )
    .settings(
      testFrameworks += new TestFramework("zio.test.sbt.ZTestFramework")
    )

lazy val crossProjectJVM: sbt.Project =
  crossProj.jvm

lazy val crossProjectNative: sbt.Project =
  crossProj.native

lazy val root: sbt.Project = (project in file("."))
  .settings(
    publish / skip := true,
    compile / skip := true,
    test / skip := true,
    doc / aggregate := false,
    crossScalaVersions := Nil,
    packageDoc / aggregate := false
  )
  .aggregate(
    crossProjectJVM,
    crossProjectNative
  )

// <https://github.com/scala-native/scala-native.g8> --- {{{

// --- }}}

// <scala/scalatest-example.g8> --- {{{

// --- }}}
