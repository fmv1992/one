# `one`

Print stdin to stdout of the number of lines is exactly n (default n=1).

Examples:

*   ```
    printf 'valid' | one
    ```

    *   Stdout: `valid` (one line).

    *   Exit code: 0.

*   ```
    printf 'invalid01\ninvalid02\n' | one
    ```

    *   Stdout: empty.

    *   Stderr:

        ```
        Got 2 lines, expected 1:
        ———
        invalid01
        invalid02
        ———
        ```

    *   Exit code: 1.

*   ```
    seq 1 5 | one --lines 5
    ```

    *   Stdout:

        ```
        1
        2
        3
        4
        5
        ```

    *   Exit code: 0.

## Testing

```
rm ./bin/one*
make format host_compile host_run host_test
```

## Installing

```
rm ./bin/one*
make format host_compile host_run host_test release
sudo make install
```

## Quality standards

*   <https://keepachangelog.com/en/1.0.0/>.

*   <https://semver.org/spec/v2.0.0.html>.
