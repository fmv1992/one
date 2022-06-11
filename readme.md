[![Build Status](https://travis-ci.org/fmv1992/one.svg?branch=dev)](https://travis-ci.org/fmv1992/one)

# `one`

If the stdin has only one line prints it. Otherwise fails.

* * *

This has not seen development for a log time and therefore it is archived (2022-06-11).

* * *

Like unix [coreutils](https://www.gnu.org/software/coreutils/) [head](https://man7.org/linux/man-pages/man1/head.1.html):

```
head -n 1
```

But this one fails (and it does not print anything) if it reads more than 1 line of stdin.

## TODO

*   Take this into account <https://gitter.im/ZIO/Core?at=601c19bb9fa6765ef8f9ee11>.

    Delete this: `one:39d3f40:one/src/main/scala/_delete_me_in_the_future.scala:1` once there's official support.

*   Generalize this program with `--n` with default of `1`.

*   Expand tests: `one:8ec5b90:other/test/bash/test.sh:17`.

*   Add Travis CI support.

*   Test `stderr` message.
