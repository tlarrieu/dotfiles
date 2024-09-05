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
  case now
    echo -e "\e[35mCurrent balance (checked transactions only)\e[0m"
    ft bal --empty -p today -C -H type:C not:tag:miriam
    echo -e "\e[35mPending balance (all transactions)\e[0m"
    ft bal --empty -p today -H type:C not:tag:miriam
    echo -e "\e[35mMonthly envelopes\e[0m"
    ft bal --empty -p thismonth expenses:groceries expenses:restaurant expenses:leisure not:tag:miriam
    echo -e "\e[35mYearly envelopes\e[0m"
    ft bal --empty -p thisyear expenses:clothing expenses:gifts not:tag:miriam
    return
  case up upcoming
    ft areg assets:check:ce tag:generated-transaction 'expenses|loan' --fore=today.. -p thismonth -w (math "min $COLUMNS,100")
    return
  case bud budget
    ft bal --budget -p thismonth not:tag:miriam --empty
    return
  case we weeks
    ft bs --fore=tomorrow.. -W -p today..30days not:tag:miriam
    return
  case mo months
    ft bs --fore=tomorrow.. -M -p 1..6months not:tag:miriam
    return
  case 2024
    ft bs --fore=tomorrow.. -M -b 2024/06 -e 2025 --color=always | less -RS
    return
  case 2025
    ft bs --fore=tomorrow.. -M -p 2025 --color=always | less -RS
    return
  end

  echo -n -e "\e[1;38m"
  echo hledger $argv $flags
  echo -n -e "\e[0m"

  hledger $argv 1> /dev/null; and hledger -f ~/.hledger.journal $argv $flags
end
