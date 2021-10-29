highlight='\033[0;31m'
echo -e "${highlight}---------------------------------------------"
date
echo building local static file...
echo -e "${highlight}---------------------------------------------"

npm run build
echo -e "${highlight}---------------------------------------------"
date
echo building docker image...
echo -e "${highlight}---------------------------------------------"
docker rmi --force 192.168.193.72:5000/blog:latest
docker build . -t 192.168.193.72:5000/blog:latest --no-cache
echo -e "${highlight}---------------------------------------------"
date
echo pushing docker image...
echo -e "${highlight}---------------------------------------------"

docker push 192.168.193.72:5000/blog:latest
echo -e "${highlight}---------------------------------------------"
date
echo sync to github
echo -e "${highlight}---------------------------------------------"
git add . && git commit -m "docker auto deploy"
git push origin master
echo -e "${highlight}---------------------------------------------"
date
echo deploy success!
echo -e "${highlight}---------------------------------------------"
exit 0