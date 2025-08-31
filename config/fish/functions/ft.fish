function now
  hledger bal --empty $argv --strict --pretty --auto
end

function up
  hledger reg $argv 'expr:tag:generated-transaction OR status:!' --fore=tomorrow..14days type:LCX --strict -w 173
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
  case sum
    echo -e "\e[32m• Current checking balance (checked transactions only) -----\e[0m"
    now -p today -C -H assets:check assets:cash assets:swile assets:amazon
    echo -e "\e[33m• Pending checking balance (all transactions) --------------\e[0m"
    now -p today..15days -H assets:cash assets:check assets:swile
    echo -e "\e[34m• Current savings balance ----------------------------------\e[0m"
    now -p today..15days -H assets:savings
    return
  case now
    echo -e "\e[32m• Current checking balance (checked transactions only) -----\e[0m"
    now -p today -C -H assets:check assets:cash assets:swile assets:amazon
    echo -e "\e[33m• Pending checking balance (all transactions) --------------\e[0m"
    now -p today..15days -H assets:cash assets:check assets:swile
    echo -e "\e[34m• Current savings balance ----------------------------------\e[0m"
    now -p today..15days -H assets:savings
    echo -e "\e[35m• Monthly envelopes ----------------------------------------\e[0m"
    now -p thismonth expenses:groceries expenses:restaurant expenses:leisure expenses:books expenses:car
    echo -e "\e[35m• Yearly envelopes -----------------------------------------\e[0m"
    now -p thisyear --depth 2 expenses:clothing expenses:gifts expenses:groceries expenses:restaurant expenses:books expenses:home expenses:car
    return
  case up upcoming
    echo -e "\e[33mUpcoming transactions (forecasted OR pending) \e[0m"
    echo -e "\e[96m• Caisse d'Épargne -----\e[0m"
    up assets:check:caisse-epargne
    set_color -d brblack
    echo
    now assets:check:caisse-epargne -p today -C -H
    echo
    set_color normal
    echo -e "\e[96m• Banque postale -------\e[0m"
    up assets:check:banque-postale
    set_color -d brblack
    echo
    now assets:check:banque-postale -p today -C -H --layout=tall
    echo
    set_color normal
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
