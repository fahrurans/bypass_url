url=$1
if [[ "$url" == "ouo.io" ]]; then
  ck=".ck.txt"
  res=$(curl -ls $url -c $ck)
  while true; do
    if [[ "$res" == "x-token" ]] && [[ "$res" == "_token" ]] && ! [[ $res == "Redirecting to" ]]; then
      token=$(echo $res | grep -Po '(?<=_token"\stype\="hidden"\svalue\=")([^"]+)')
      url=$(echo $res | grep -Po '(?<=action\=")(http[^"]+)')
      res=$(curl $url -sd "_token=$token&x-token=&v-token=" -b $ck)
      echo -e "\x1b[96m[REDIRECT]\x1b[0m $url "
    elif [[ "$res" == "Redirecting to" ]]; then
      res_url=$(echo $res | grep -Po '(?<=content\="1;url\=)([^"]+)')
      echo -e "\x1b[92m[FOUND]\x1b[0m $res_url "
      break
    else
      echo -e "\x1b[91m[ERROR]\x1b[0m link anda bermasalah "
      break
    fi
  done
  rm -rf $ck
else
  echo "ex: bash $0 ouo.io/xxxx"
fi
