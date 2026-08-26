# this file is both a valid
# - overlay which can be loaded with `overlay use starship.nu`
# - module which can be used with `use starship.nu`
# - script which can be used with `source starship.nu`
let vi_insert = {
    fg: '#34364A'   # ink
    bg: '#F4A7BB'   # strawberry
    attr: b
}

let vi_insert_cap = {
    fg: '#F4A7BB'
    attr: b
}

let vi_normal = {
    fg: '#34364A'   # ink
    bg: '#C6B4E3'   # lavender
    attr: b
}

let vi_normal_cap = {
    fg: '#C6B4E3'
    attr: b
}

let vi_insert_separator = {
    fg: '#9FAFE0'   # periwinkle from clock
    bg: '#F4A7BB'   # strawberry
}

let vi_normal_separator = {
    fg: '#9FAFE0'   # periwinkle from clock
    bg: '#C6B4E3'   # lavender
}

export-env { $env.STARSHIP_SHELL = "nu"; load-env {
    STARSHIP_SESSION_KEY: (random chars -l 16)
    PROMPT_MULTILINE_INDICATOR: (
        ^/usr/bin/starship prompt --continuation
    )

    
    # Does not play well with default character module.
    # TODO: Also Use starship vi mode indicators?
    PROMPT_INDICATOR: ""

    PROMPT_INDICATOR_VI_INSERT: $"(ansi --escape $vi_insert_separator)(ansi reset)(ansi --escape $vi_insert) INSERT (ansi reset)(ansi --escape $vi_insert_cap)(ansi reset) "

    PROMPT_INDICATOR_VI_NORMAL: $"(ansi --escape $vi_normal_separator)(ansi reset)(ansi --escape $vi_normal) NORMAL (ansi reset)(ansi --escape $vi_normal_cap)(ansi reset) "
    PROMPT_COMMAND: {||
        (
            # The initial value of `$env.CMD_DURATION_MS` is always `0823`, which is an official setting.
            # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
            let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS };
            ^/usr/bin/starship prompt
                --cmd-duration $cmd_duration
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
                ...(
                    if (which "job list" | where type == built-in | is-not-empty) {
                        ["--jobs", (job list | length)]
                    } else {
                        []
                    }
                )
        )
    }

    config: ($env.config? | default {} | merge {
        render_right_prompt_on_last_line: true
    })

    PROMPT_COMMAND_RIGHT: {||
        (
            # The initial value of `$env.CMD_DURATION_MS` is always `0823`, which is an official setting.
            # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
            let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS };
            ^/usr/bin/starship prompt
                --right
                --cmd-duration $cmd_duration
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
                ...(
                    if (which "job list" | where type == built-in | is-not-empty) {
                        ["--jobs", (job list | length)]
                    } else {
                        []
                    }
                )
        )
    }
}}
