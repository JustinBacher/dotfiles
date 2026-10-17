function ssh
    # Attach to the shared tmux session only for a bare connect (host, plus flags).
    # `ssh host cmd ...` passes straight through so remote commands still run.
    set -l positional (string match -rv '^-' -- $argv)
    if set -q TMUX; and test (count $positional) -eq 1
        command ssh -t $argv tmux new-session -A -s main
    else
        command ssh $argv
    end
end
