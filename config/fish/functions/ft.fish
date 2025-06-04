function ft
  set -l flags --strict
  switch $argv[1]
  case edit
    nvim -p (readlink -f ~/.hledger/current.journal)
    return
  case bal bs bse is cf roi
    set flags $flags --pretty --auto
    if [ $argv[1] != roi ]
      set flags $flags --layout=bare
    end
    if [ $argv[1] = bse ]
      # resolve accounting equation
      set flags $flags --alias '/^(income|expenses)/=equity:\1'
    end
  case areg reg
    set flags $flags -w (math "min $COLUMNS,100")
  case now
    echo -e "\e[32mCurrent balance (checked transactions only)\e[0m"
    ft bal --empty -p today -C -H type:C not:tag:miriam
    echo -e "\e[33mPending balance (all transactions)\e[0m"
    ft bal --empty -p today..15days -H type:C not:tag:miriam
    # echo -e "\e[34mPending balance (business expenses)\e[0m"
    # ft bal tag:business type:RX --empty -p today -H
    echo -e "\e[35mMonthly envelopes\e[0m"
    ft bal --empty -p thismonth expenses:groceries expenses:restaurant expenses:leisure not:tag:miriam
    echo -e "\e[35mYearly envelopes\e[0m"
    ft bal --empty -p thisyear expenses:clothing expenses:gifts not:tag:miriam
    return
  case up upcoming
    echo -e "\e[35mUpcoming transactions (forecasted OR pending) \e[0m"
    ft reg assets:check expr:'tag:generated-transaction OR status:!' type:LCX --fore=today.. -p ..14days not:tag:miriam
    echo -e "\e[35mCurrent balance\e[0m"
    ft bal assets:check -p today -C -H not:tag:miriam
    return
  case bud budget
    ft bal --budget -p thismonth not:tag:miriam --empty
    return
  case we weeks
    ft bs --fore=tomorrow.. -W -p today..30days
    return
  case mo months
    ft bs --fore=tomorrow.. -M -p 1..6months
    return
  case 2024
    ft bs --fore=tomorrow.. -M -b 2024/06 -e 2025 not:tag:miriam --color=always | less -RS
    return
  case 2025
    ft bs --fore=tomorrow.. -M -p 2025 --color=always | less -RS
    return
  end

  set fish_trace 1
  hledger $argv $flags
end
