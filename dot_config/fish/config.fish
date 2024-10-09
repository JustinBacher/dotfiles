set -gx EDITOR nvim
set -gx PAGER most

if status is-interactive
	and not set -q TMUX
    	exec tmux 
end

# may want to set this later to something but stop greeting me every time fish :) lvu
set -g fish_greeting

set -l foreground c8d3f5 #c8d3f5
set -l selection 2d3f76 #2d3f76
set -l comment 636da6 #636da6
set -l red ff757f #ff757f
set -l orange ff966c #ff966c
set -l yellow ffc777 #ffc777
set -l green c3e88d #c3e88d
set -l purple fca7ea #fca7ea
set -l cyan 86e1fc #86e1fc
set -l pink c099ff #c099ff

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $pink
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment
# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection

# Enable vim mode
if status is-interactive
  set fish_cursor_default     block      blink
  set fish_cursor_insert      line       blink
  set fish_cursor_replace_one underscore blink
  set fish_cursor_visual      block

  function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
  end
end

thefuck --alias | source
zoxide init --cmd cd fish | source
