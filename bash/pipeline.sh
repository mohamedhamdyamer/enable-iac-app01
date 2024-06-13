#!/bin/bash

# Assigning parameters ...
while getopts "a:r:p:" my_param
do
  case "${my_param}" in
    a) account_name=${OPTARG};;
    r) repo_name=${OPTARG};;
    p) my_password=${OPTARG};;
  esac
done

# Verifying the supplied account and repo names are valid
# Repo url example --> git@github.com:mohamedhamdyamer/enable-iac-app01.git
if [[ -z $account_name ]]; then
  echo "Missing Account Name! please provie a valid GitHub account using the -a option."
  exit 1
elif [[ -z $repo_name ]]; then
  echo "Missing Repo Name! please provie a valid GitHub repo using the -r option."
  exit 1
fi

repo_url_api="https://api.github.com/repos/"$account_name"/"$repo_name

curl_msg=`gh api $repo_url_api | jq '.message'`
if [[ $curl_msg == '"Not Found"' ]]; then
  echo "GitHub Repo not found!"
  exit 1
fi

echo "Valid Account and Repo have been supplied!"
echo "Account Name: "$account_name
echo "Repo Name: "$repo_name

repo_url="git@github.com:"$account_name"/"$repo_name".git"
echo "Repo URL (SSH): "$repo_url
echo "Repo URL (APIs): "$repo_url_api

repo_url_api_releases_latest="https://api.github.com/repos/"$account_name"/"$repo_name"/releases/latest"
repo_url_api_commits="https://api.github.com/repos/"$account_name"/"$repo_name"/commits"

# Fetching the repo ...
echo "----------"
echo "Fetching the repo ..."

found=`ls -ltr . | grep -w workspace | wc -l`
if [[ $found -eq 0 ]]; then
  mkdir workspace
fi
found=`ls -ltr ./workspace | grep -w tmp | wc -l`
if [[ $found -eq 0 ]]; then
  mkdir ./workspace/tmp
fi

rm -rf ./workspace/repo
git clone $repo_url ./workspace/repo

clone_date_time=`date +%Y%m%d-%H%M%S`
work_directory="./workspace/tmp/"$clone_date_time
mkdir "$work_directory"
cp ./workspace/repo/* "$work_directory"

echo "----------"
echo "repo fetched successfully!"

latest_version=`gh api $repo_url_api_releases_latest | jq ".name"`
latest_version=`echo $latest_version | cut --delimiter '"' --fields 2`
echo "Latest Version: "$latest_version

echo "----------"
commits_length=`gh api $repo_url_api_commits | jq length`
echo "Commits("$commits_length"):"

echo "----------"
block=""
row="Commit Message|Author"
block=$block$row"\n"
row="--------------|------"
block=$block$row"\n"

for (( i=0; i<$commits_length; i++ ))
do
  row=`gh api $repo_url_api_commits | jq ".[$i].commit.message"`
  row=$row"|"
  row=$row`gh api $repo_url_api_commits | jq ".[$i].commit.author.name"`
  block=$block$row"\n"
done
echo -e $block | column -t -s "|"
echo "----------"
echo "Working Directory: "$work_directory
# End - Fetching the repo

# Building ...
echo "----------"
echo "Building ..."

sed -i 's/Platform:/Deploy Platform: Containers (Docker)/g' $work_directory/index.html
sed -i 's/Environment:/Environment: Test/g' $work_directory/index.html
sed -i "s/[0-9].[0-9]/"$latest_version"/g" $work_directory/index.html
build_number_file_exists=`ls -ltr | grep -i build_number | wc -l`
if [[ $build_number_file_exists -eq 0 ]]; then
  build_number="1"
  touch build_number
  echo $build_number > ./build_number
else
  build_number=`cat build_number`
  build_number=$[build_number+1]
  echo $build_number > ./build_number
fi
sed -i "s/Build Number:/Build Number: "$build_number"/g" $work_directory/index.html
sed -i "s/[a-z][0-9].[0-9].[0-9]/"$latest_version"."$build_number"/g" $work_directory/index.html

cp ./Dockerfile $work_directory
myapp_image="myapp_image"
echo $my_password | sudo -S docker build -t $myapp_image $work_directory
# End - Building

# Deploying ...
myapp="myapp"
result=`echo $my_password | sudo -S docker ps | grep -i $myapp | wc -l`
if [[ $result -eq 1 ]]; then
  echo $my_password | sudo -S docker stop $myapp
fi
echo $my_password | sudo -S docker run --name $myapp --rm -d -p 8080:80 $myapp_image
echo $my_password | sudo -S docker image prune --all --force
# End - Deploying
