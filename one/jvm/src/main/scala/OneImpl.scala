package fmv1992.one

object OneImpl extends fmv1992.one.One {

  def getInput(): Iterable[String] = {
    LazyList.continually(scala.io.StdIn.readLine()).takeWhile(_ != null)
  }

}
