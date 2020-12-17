scalaVersion := "2.11.12"

// Set to false or remove if you want to show stubs as linking errors
nativeLinkStubs := true
nativeLinkStubs in runMain := true
Test / nativeLinkStubs := true

libraryDependencies += "org.scalatest" %%% "scalatest" % "3.1.0" % Test
libraryDependencies += "io.github.fmv1992" %%% "scala_cli_parser" % "[0.0,9.0]"
Global / onChangedBuildSource := ReloadOnSourceChanges

artifactPath in (Compile, nativeLink) := {
crossTarget.value / "one"
}

enablePlugins(ScalaNativePlugin)

lazy val root: sbt.Project = (project in file("."))
