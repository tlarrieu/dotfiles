function now
  hledger bal --empty $argv --strict --pretty --auto --layout=bare
end

function forecast
  ft bs --fore=tomorrow.. $argv
end

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
    echo -e "\e[32m• Current checking balance (checked transactions only) -----\e[0m"
    now -p today -C -H assets:check assets:cash assets:swile assets:amazon
    echo -e "\e[33m• Pending checking balance (all transactions) --------------\e[0m"
    now -p today..15days -H assets:check assets:swile
    echo -e "\e[34m• Current savings balance ----------------------------------\e[0m"
    now -p today..15days -H assets:savings
    echo -e "\e[35m• Monthly envelopes ----------------------------------------\e[0m"
    now -p thismonth expenses:groceries expenses:restaurant expenses:leisure expenses:books
    echo -e "\e[35m• Yearly envelopes -----------------------------------------\e[0m"
    now -p thisyear expenses:clothing expenses:gifts expenses:groceries expenses:restaurant expenses:books expenses:home
    return
  case up upcoming
    echo -e "\e[35mUpcoming transactions (forecasted OR pending) \e[0m"
    ft reg assets:check expr:'tag:generated-transaction OR (status:! AND date:..14days)' --fore=tomorrow..14days type:LCX
    echo -e "\e[35mCurrent balance\e[0m"
    ft bal assets:check -p today -C -H
    return
  case bud budget
    ft bal --budget -p thismonth --empty
    return
  case we weeks
    forecast -W -p today..30days
    return
  case mo months
    forecast -M -p 1..6months
    return
  case ye year
    forecast -M -p 2025 --color=always | less -RS
    return
  end

  set fish_trace 1
  hledger $argv $flags
end
