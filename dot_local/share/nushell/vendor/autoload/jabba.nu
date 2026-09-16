# https://github.com/Jabba-Team/jabba
# Ported from /home/linuxbrew/.linuxbrew/opt/jabba/jabba.fish

export-env {
    if not ("JABBA_HOME" in $env) {
        let candidate = "/home/linuxbrew/.linuxbrew/opt/jabba"
        let cellar = "/home/linuxbrew/.linuxbrew/Cellar/jabba/0.15.0"
        let alt_candidate = "/var/home/linuxbrew/.linuxbrew/opt/jabba"
        let alt_cellar = "/var/home/linuxbrew/.linuxbrew/Cellar/jabba/0.15.0"
        $env.JABBA_HOME = if ($candidate | path exists) {
            $candidate
        } else if ($cellar | path exists) {
            $cellar
        } else if ($alt_candidate | path exists) {
            $alt_candidate
        } else if ($alt_cellar | path exists) {
            $alt_cellar
        } else {
            "/home/linuxbrew/.linuxbrew/opt/jabba"
        }
    }
}

export def --wrapped --env jabba [...params: string] {
    let jabba_bin = if ("JABBA_HOME" in $env and (($env.JABBA_HOME | path join "bin" "jabba") | path exists)) {
        $env.JABBA_HOME | path join "bin" "jabba"
    } else if ("/home/linuxbrew/.linuxbrew/opt/jabba/bin/jabba" | path exists) {
        "/home/linuxbrew/.linuxbrew/opt/jabba/bin/jabba"
    } else if ("/home/linuxbrew/.linuxbrew/Cellar/jabba/0.15.0/bin/jabba" | path exists) {
        "/home/linuxbrew/.linuxbrew/Cellar/jabba/0.15.0/bin/jabba"
    } else if ("/var/home/linuxbrew/.linuxbrew/opt/jabba/bin/jabba" | path exists) {
        "/var/home/linuxbrew/.linuxbrew/opt/jabba/bin/jabba"
    } else if ("/var/home/linuxbrew/.linuxbrew/Cellar/jabba/0.15.0/bin/jabba" | path exists) {
        "/var/home/linuxbrew/.linuxbrew/Cellar/jabba/0.15.0/bin/jabba"
    } else {
        "jabba"
    }

    let fd3 = (mktemp -t jabba-fd3.XXXXXX.env)
    let res = (do {
        with-env { JABBA_SHELL_INTEGRATION: "ON" } {
            ^$jabba_bin ...$params --fd3 $fd3
        }
    } | complete)

    if not ($res.stderr | is-empty) {
        print -e -n $res.stderr
    }

    if ($fd3 | path exists) {
        if ((ls $fd3 | get -o 0.size? | default 0B) > 0B) {
            let lines = (open $fd3 | lines | each { str trim } | where { is-not-empty })
            for line in $lines {
                if ($line | str starts-with "export ") {
                    let m = ($line | parse --regex "^export (?P<name>[^=]+)=\"(?P<value>.*)\"$")
                    if not ($m | is-empty) {
                        let row = ($m | first)
                        if $row.name == "PATH" {
                            $env.PATH = ($row.value | split row (char esep))
                        } else {
                            load-env { ($row.name): $row.value }
                        }
                    }
                } else if ($line | str starts-with "unset ") {
                    let name = ($line | str substring 6.. | str trim)
                    hide-env -i $name
                }
            }
        }
        try { rm -f $fd3 }
    }

    $env.LAST_EXIT_CODE = $res.exit_code
    if not ($res.stdout | is-empty) {
        $res.stdout
    }
}

# Auto-use default alias if configured
let _default_alias = try {
    let _bin = if ("JABBA_HOME" in $env and (($env.JABBA_HOME | path join "bin" "jabba") | path exists)) {
        $env.JABBA_HOME | path join "bin" "jabba"
    } else if ("/home/linuxbrew/.linuxbrew/opt/jabba/bin/jabba" | path exists) {
        "/home/linuxbrew/.linuxbrew/opt/jabba/bin/jabba"
    } else if ("/var/home/linuxbrew/.linuxbrew/opt/jabba/bin/jabba" | path exists) {
        "/var/home/linuxbrew/.linuxbrew/opt/jabba/bin/jabba"
    } else {
        "jabba"
    }
    ^$_bin alias default | str trim
} catch { "" }

if not ($_default_alias | is-empty) {
    jabba use default
}
