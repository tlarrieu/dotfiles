function tab
  awk '{print "  " $0}'
end

function myip
  echo "Local IP:"
  /sbin/ifconfig | awk '/inet/ { print $2 } ' | sed -e s/adr:// | sed -e s/inet6:// | tab

  echo
  echo "Public IP:"
  curl https://api.ipify.org 2> /dev/null | tab
end
