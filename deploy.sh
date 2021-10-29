highlight='\033[0;31m'
NC='\033[0m'
echo "${highlight}---------------------------------------------${NC}"
date
echo building local static file...
echo "${highlight}---------------------------------------------${NC}"

npm run build
echo "${highlight}---------------------------------------------${NC}"
date
echo building docker image...
echo "${highlight}---------------------------------------------${NC}"
docker rmi --force 192.168.193.72:5000/blog:latest
docker build . -t 192.168.193.72:5000/blog:latest --no-cache
echo "${highlight}---------------------------------------------${NC}"
date
echo pushing docker image...
echo "${highlight}---------------------------------------------${NC}"

docker push 192.168.193.72:5000/blog:latest
echo "${highlight}---------------------------------------------${NC}"
date
echo sync to github
echo "${highlight}---------------------------------------------${NC}"
git add . && git commit -m "docker auto deploy"
git push origin master
echo "${highlight}---------------------------------------------${NC}"
date
echo deploy success!
echo "${highlight}---------------------------------------------${NC}"
exit 0