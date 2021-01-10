# `one`

If the stdin has only one line prints it. Otherwise fails.

* * *

Like unix [coreutils](https://www.gnu.org/software/coreutils/) [head](https://man7.org/linux/man-pages/man1/head.1.html):

```
head -n 1
```

But this one fails (and it does not print anything) if it reads more than 1 line of stdin.

## TODO

*   Add Travis CI support.

*   Test `stderr` message.
