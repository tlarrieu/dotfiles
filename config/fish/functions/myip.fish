function tab
  awk '{print "  " $0}'
end

function myip
  set -l ip /usr/bin/ip
  set -l curl /usr/bin/curl

  set -l device ($ip route | head -n1 | awk '{ print $5 }')

  echo "Local IP (guessing $device as the default device):"
  $ip -4 a s $device | awk '/inet/ { print $2 } ' | tab

  echo
  echo "Public IP:"
  $curl https://api.ipify.org 2> /dev/null | tab
end
