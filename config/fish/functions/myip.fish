function myip
  /sbin/ifconfig | awk '/inet/ { print $2 } ' | sed -e s/adr:// | sed -e s/inet6://
end
