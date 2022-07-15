# run the server locally
cd tls_webserver
python3 app.py $1 &
cd ..

# let the server up and running
sleep 5

# replace ip address in student solution
sed -i "s/16\.16\.53\.16/127\.0\.0\.1/g" tlsHandshake.sh

# run student solution
bash -x tlsHandshake.sh > output
SOL_EXIT=$?

# get results
curl 127.0.0.1:8080/flush &> /dev/null

# kill the server
kill -9 $! &> /dev/null
echo
echo

set -e

# solution test cases
if [[ $1 = "eve" ]]
then

  if [[ "$SOL_EXIT" -ne 1 ]] || ! grep -q 'is invalid' output
  then
    echo "Expected exit code 1 and 'Server Certificate is invalid.' to be printed to stdout since client has responded with Eve certificate."
    exit 1
  fi

  echo "Well Done! you've passed Eve certificate tests"

elif [[ $1 = "bad-msg" ]]
then

    if [[ "$SOL_EXIT" -ne 1 ]] || ! grep -q 'symmetric .* has failed' output
    then
      echo "Expected exit code 1 and 'Server symmetric encryption using the exchanged master-key has failed.' to be printed to stdout because the server encrypted the wrong client test message."
      exit 1
    fi

      echo "Well Done! you've passed bad client message encryption tests"

else

  L=$(jq length tls_webserver/secrets.json)
  if [ "$L" != 1 ]; then
      echo "Expected server to get Client Hello message only once, but called $L"
      exit 1
  fi

  echo "Well Done! you've passed full handshake tests"

fi

