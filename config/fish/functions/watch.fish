function watch
  argparse -i n/interval= -- $argv

  set -l flags
  if set -ql _flag_n
    set flags "-n" $_flag_interval
  end

  command watch $flags --color --exec fish -c "$argv"
end
