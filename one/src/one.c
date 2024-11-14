#define _POSIX_C_SOURCE 200112L
#include <argp.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

constexpr int N_LINES_TOTAL_MAX = 100;
/* constexpr int N_CONTEXT_LINES_DEFAULT = 5;*/

/* constexpr int N_LINES_LIMIT_MIN = 1;*/
/* constexpr int N_LINES_LIMIT_MAX = 10001;*/

constexpr int MAX_LINE_LENGTH = 10000;

// Argparse. --- {{{

const char *argp_program_version = "one v0.0.1 " GIT_COMMIT;

const char *argp_program_bug_address = "fmv1992@gmail.com";

static char args_doc[] = "";

static char doc[] =
    "Print stdin to stdout of the number of lines is exactly n (default n=1).";

struct arguments {
    int n_expected_lines;
    bool empty;
};

static struct argp_option options[] = {
    { "lines", 'n', "n_expected_lines", 0,
     "How many lines to print, in case stdin has **exactly** that many lines.",
     0 },
    { "empty", 'e', 0, 0, "Check that the input has in fact zero bytes.", 0 },
    { 0 }
};

/* Parse a single option. */
static error_t parse_opt(int key, char *arg, struct argp_state *state)
{
    /* Get the input argument from argp_parse, which we
       know is a pointer to our arguments structure. */
    struct arguments *arguments = state->input;

    switch (key) {
    case 'n':
        arguments->n_expected_lines = atoi(arg);
        break;
    case 'e':
        arguments->empty = true;
        break;
    case ARGP_KEY_ARG:
        if (state->arg_num >= 2)
            /* Too many arguments. */
            argp_usage(state);

        /* arguments->args[state->arg_num] = arg; */

        break;

    default:
        return ARGP_ERR_UNKNOWN;
    }
    return 0;
}

static struct argp argp = { options, parse_opt, args_doc, doc, NULL, 0, 0 };

// --- }}}


static void terminate_due_to_wrong_number_of_observed_lines(int lines_seen,
                                                            int lines_expected,
                                                            char lines[]
                                                            [MAX_LINE_LENGTH],
                                                            int *exit_code)
{
    char sep[] = "———";
    fprintf(stderr, "Got %d lines, expected %d:\n%s\n", lines_seen,
            lines_expected, sep);
    for (int i = 0; i < lines_seen; i++) {
        fprintf(stderr, lines[i], lines_seen, lines_expected);
    }
    fprintf(stderr, "%s\n", sep);
    *exit_code = 1;
}

int empty(struct arguments arguments)
{
    (void) arguments;
    if (getchar() != EOF) {
        fprintf(stderr, "`one`: stdin not empty.");
        exit(4);
    }
    return 0;
}

int one(struct arguments arguments)
{
    int exit_code = -1;

    int n_expected_lines = arguments.n_expected_lines;

    char line[MAX_LINE_LENGTH];
    char lines[N_LINES_TOTAL_MAX][MAX_LINE_LENGTH];

    // ???: Assert that `n_expected_lines <= N_LINES_TOTAL_MAX`.

    int lines_seen = 0;
    while (fgets(line, MAX_LINE_LENGTH, stdin) != NULL) {
        lines_seen++;
        // fprintf(stderr, "lines_seen=%d, n_expected_lines=%d\n", lines_seen,
        // n_expected_lines);
        strcpy(lines[lines_seen - 1], line);
        if (lines_seen > n_expected_lines || lines_seen > N_LINES_TOTAL_MAX)
            break;
    }
    if (lines_seen > n_expected_lines) {
        terminate_due_to_wrong_number_of_observed_lines(lines_seen,
                                                        n_expected_lines,
                                                        lines, &exit_code);
    }
    if (lines_seen > N_LINES_TOTAL_MAX) {
        fprintf(stderr, "The amount of seen lines exceeded %d.",
                N_LINES_TOTAL_MAX);
        exit_code = 2;
    }
    if (lines_seen == n_expected_lines && feof(stdin)) {
        for (int i = 0; i < lines_seen;) {
            printf("%s", lines[i++]);
        }
        exit_code = EXIT_SUCCESS;
    }
    // This sends `SIGPIPE` to all processes in the same process group:
    //
    // // ```
    // //
    // // This allow an instant termination of piped processes; see
    // // `tag:9bbd8706`.
    // // fprintf(stderr, "`exit_code`=%d", exit_code);
    // if (exit_code != EXIT_SUCCESS) {
    //     // Ignore the pipe fail sent to itself.
    //     signal(SIGPIPE, SIG_IGN);
    //     kill(0, SIGPIPE);
    //     exit(exit_code);
    // } else {
    //     exit(exit_code);
    // }
    // // ```
    //
    // The problem is that testing causes all other process to exit without
    // a 0 signal, e.g.:
    //
    // ```
    // cmp <(printf '' || true | ./bin/one || true) <(printf '')
    // ```
    //
    // Therefore if there's a super long process, although this one has already
    // finished, that one will continue to run.
    //
    // ???: This can become a CLI in the future.
    exit(exit_code);
}

int main(int argc, char **argv)
{
    struct arguments arguments;

    // Default values.
    arguments.n_expected_lines = -1;
    arguments.empty = false;

    argp_parse(&argp, argc, argv, 0, 0, &arguments);

    if (arguments.empty && arguments.n_expected_lines != -1) {
        fprintf(stderr, "Only one of `--lines x` or `--empty` can be set.\n");
        exit(3);
    }
    if (arguments.empty) {
        empty(arguments);
    // } else {
    //     if (arguments.n_expected_lines == -1) {
    //         arguments.n_expected_lines = 1;
    //     }
    //     one(arguments);
    // }
    } else {
        one(arguments);
    }
}
