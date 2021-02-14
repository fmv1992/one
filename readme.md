[![Build Status](https://travis-ci.org/fmv1992/one.svg?branch=dev)](https://travis-ci.org/fmv1992/one)

# `one`

If the stdin has only one line prints it. Otherwise fails.

* * *

Like unix [coreutils](https://www.gnu.org/software/coreutils/) [head](https://man7.org/linux/man-pages/man1/head.1.html):

```
head -n 1
```

But this one fails (and it does not print anything) if it reads more than 1 line of stdin.

## TODO

*   Take this into account <https://gitter.im/ZIO/Core?at=601c19bb9fa6765ef8f9ee11>.

*   Add Travis CI support.

*   Test `stderr` message.
