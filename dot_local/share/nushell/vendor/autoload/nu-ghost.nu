$env.config.show_hints = true

let nu_ghost_status = (
  try { ^nu-ghost status | complete } catch { { stdout: "", stderr: "", exit_code: 1 } }
)

let nu_ghost_daemon_running = (
  $nu_ghost_status.exit_code == 0 and
  (try { (($nu_ghost_status.stdout | from json).type? | default "") == "status" } catch { false })
)

$env.config.hinter.closure = if $nu_ghost_daemon_running {
  {|ctx|
    let line_len = ($ctx.line | str length --utf-8-bytes)
    if (($ctx.line | str trim | str length) == 0) or $ctx.pos != $line_len {
      null
    } else {
      let command = (try {
        $ctx
        | merge { history_path: (try { $nu.history-path } catch { null }) }
        | to json -r
        | ^nu-ghost suggest
        | complete
      } catch {
        null
      })

      let response = if ($command == null) or (($command.exit_code? | default 1) != 0) {
        null
      } else {
        try { $command.stdout | from json } catch { null }
      }

      if $response == null {
        null
      } else {
        ($response.hint? | default "")
      }
    }
  }
} else {
  null
}

$env.config.hooks.pre_execution = (
  $env.config.hooks.pre_execution? | default [] | append {||
    try {
      {
        event: "execute"
        line: (commandline)
        cwd: (pwd)
        ts: (date now | into int)
      }
      | to json -r
      | ^nu-ghost event
      | ignore
    }
  }
)
