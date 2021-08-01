package fmv1992.one

import scala.scalanative.unsafe._
import scala.scalanative.libc._

object OneImpl extends fmv1992.one.One {

  def getInput(): Iterable[String] = {
    var lines: scala.collection.mutable.Queue[String] =
      scala.collection.mutable.Queue()
    val lineInBuffer = stackalloc[Byte](10 * 1024)
    while (stdio.fgets(lineInBuffer, 10 * 1024, stdio.stdin) != null) {
      lines.append(fromCString(lineInBuffer))
    }
    lines.to(LazyList)
  }

}
