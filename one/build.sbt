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
      scalaVersion.value,
    ),
    // https://index.scala-lang.org/ohze/scala-rewrites/scala-rewrites/0.1.10-sd?target=_2.13
    semanticdbEnabled := true,
    semanticdbOptions += "-P:semanticdb:synthetics:on", // make sure to add this
    semanticdbVersion := scalafixSemanticdb.revision,
    libraryDependencies += "org.scalameta" % "semanticdb-scalac-core" % "4.4.6" cross CrossVersion.full,
    scalafixScalaBinaryVersion := CrossVersion.binaryScalaVersion(
      scalaVersion.value,
    ),
  ),
)

lazy val commonSettings = Seq(
  Compile / scalacOptions ++= {
    CrossVersion.partialVersion(scalaVersion.value) match {
      case Some((2, n)) if n == 11 => Seq()
      case Some((2, n)) if n == 12 => Seq("-Xlint:unused")
      case Some((2, n)) if n == 13 =>
        Seq(
          "-deprecation",
          "-feature",
          "-P:semanticdb:synthetics:on",
          "-Wunused",
          "-Yrangepos",
          "-Ywarn-dead-code",
        )
    }
  },
)

lazy val commonDependencies = Seq(
  libraryDependencies ++= {
    CrossVersion.partialVersion(scalaVersion.value) match {
      case Some((2, n)) if n == 13 =>
        List(
          "com.sandinh" %% "scala-rewrites" % "0.1.10-sd",
          "org.scalatest" %%% "scalatest" % "3.2.4-M1" % Test,
          "io.github.fmv1992" %%% "scala_cli_parser" % "0.2.0",
          "dev.zio" %%% "zio" % zioVersion,
          "dev.zio" %%% "zio-streams" % zioVersion,
          "dev.zio" %%% "zio-test" % zioVersion % "test",
          "dev.zio" %% "zio-test-sbt" % zioVersion % "test",
        )
      case _ => Nil
    }
  },
  mainClass in Compile := Some("fmv1992.one.One"),
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
)

lazy val crossProj: sbtcrossproject.CrossProject =
  crossProject(JVMPlatform, NativePlatform)
    .crossType(CrossType.Pure)
    .in(file("."))
    .settings(
      name := "one",
    )
    .settings(commonSettingsAndDependencies)
    .jvmSettings(
      crossScalaVersions := versionsJVM,
      mainClass in assembly := Some("fmv1992.one.One"),
    )
    .nativeSettings(
      scalaNativeSettings,
    )
    .settings(
      testFrameworks += new TestFramework("zio.test.sbt.ZTestFramework"),
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
    packageDoc / aggregate := false,
  )
  .aggregate(
    crossProjectJVM,
    crossProjectNative,
  )

// <https://github.com/scala-native/scala-native.g8> --- {{{

// --- }}}

// <scala/scalatest-example.g8> --- {{{

// --- }}}
