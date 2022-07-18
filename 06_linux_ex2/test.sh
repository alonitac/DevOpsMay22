set -e

# run the server locally
python tls_webserver/app.py $1 &

# let the server up and running
sleep 5

# replace ip address in student solution
sed -i "s/16\.16\.53\.16/127\.0\.0\.1/g" tlsHandshake.sh

# run student solution
OUTPUT=$(bash tlsHandshake.sh)
SOL_EXIT=$?

# get results
curl 127.0.0.1:8080/flush
RESPONSE=$(cat secrets.json)

# solution test cases
if [[ $1 = "eve" ]]
then
  grep -q "is invalid" "$OUTPUT"

  if [[ "$SOL_EXIT" -ne 1 || $? -eq 1 ]]
  then
    echo "Expected exit code 1 and 'Server Certificate is invalid.' to be printed to stdout since client has responded with Eve certificate."
    exit 1
  fi


else

    if ! grep -q '71444da2-4e2d-4a32-8442-393eaaf593f4' "$RESPONSE"
    then
      echo ""
      exit 1
    fi

fi

echo "Well Done! you've passed all tests"
