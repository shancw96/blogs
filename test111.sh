time=$(date "+%Y%m%d-%H%M%S")
echo "please input commit message"
read message
git add .
git commit -m "${message}"
echo "auto deploy at:${time}" > deploy.tag
git add .
git commit -m "auto deploy at ${time}"
git push origin master
