function fish_right_prompt
  set_color $fish_color_autosuggestion[1]
  ruby -v
  echo ' '
  date
  set_color normal
end
