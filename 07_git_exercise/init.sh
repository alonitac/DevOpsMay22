#!/bin/sh

REMOTES=$(git remote -v)
if [ "" != "$REMOTES" ]; then
  ORIGIN=$(git remote get-url origin)
  if [ "$ORIGIN" = "https://github.com/alonitac/DevOpsMay22.git" ]; then
    echo "This script should be executed from your private repo, not from DevOpsMay22 repo"
    exit 1
  fi
fi


if ! git checkout -b main; then
  echo "Error: Unable to checkout new branch 'main'"
  exit 1
fi

if ! git add init.sh && git commit -m "add init.sh"; then
  echo "Error: Unable to add and commit init.sh file"
  exit 1
fi

touch .gitignore
echo ".idea" >> .gitignore
echo "venv" >> .gitignore

git add .gitignore && git commit -m "add gitignore"


# general branches
git branch bugfix/fix_readme_typo
git branch feature/upgrade_angular_version
git branch feature/data_retention_policy
git branch feature/elasticsearch_helm_chart
git branch bugfix/open_kibana_port

# Changes in working tree and switch branches
git checkout -b dev

echo "a" >> take.txt
echo "b" >> take.txt
echo "c" >> take.txt

git add take.txt && git commit -m "add take.txt in dev"
git checkout main

# Reset
git checkout -b reset_question

for i in $(seq 1 10);
do
    echo "$i" > $i.txt
    git add $i.txt
    git commit -m "$i"
done

git checkout main


# Resolve conflicts
rm -f -r app.py

if ! curl -kLSs https://raw.githubusercontent.com/alonitac/DevOpsMay22/main/05_simple_webserver/app.py -o app.py; then
  echo "Error: Unable retrieve app.py from GitHub"
  exit 1
fi

git add app.py && git commit -m "add app.py"

git checkout -b feature/version1
sed -i "s/port=8080/port=8081/g" app.py
sed -i "s/profile_picture/load_profile_picture/g" app.py

git add app.py && git -c user.name='John Doe' -c user.email='john.doe@microsoft.com' commit -m "John's changes for app.py"

touch .env && git add .env
git -c user.name='John Doe' -c user.email='john.doe@microsoft.com' commit -m "use correct lock type in reconnect()"

touch config.json && git add config.json
git -c user.name='John Doe' -c user.email='john.doe@microsoft.com' commit -m "Restrict the extensions that can be disabled"


git checkout main
git checkout -b feature/version2
sed -i "s/port=8080/port=8082/g" app.py
sed -i "s/profile_picture/get_profile_picture/g" app.py
sed -i "s/POST/GET/g" app.py
git add app.py && git -c user.name='Narayan Nadella' -c user.email='narayan.nadella@microsoft.com' commit -m "Nayaran's changes for app.py"

git checkout main


echo
echo
echo "Repo initialized successfully "
echo
