highlight='\033[0;31m'
NC='\033[0m'
echo "${highlight}---------------------------------------------${NC}"
echo setting http proxy to http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
echo "${highlight}---------------------------------------------${NC}"
echo "${highlight}---------------------------------------------${NC}"
date
echo building local static file...
echo "${highlight}---------------------------------------------${NC}"

npm run build
echo "${highlight}---------------------------------------------${NC}"
date
echo building docker image...
echo "${highlight}---------------------------------------------${NC}"
docker rmi --force 	10.14.145.2:5000/blog:v1
docker build . -t 	10.14.145.2:5000/blog:v1 --no-cache
echo "${highlight}---------------------------------------------${NC}"
date
echo pushing docker image...
echo "${highlight}---------------------------------------------${NC}"

docker push 	10.14.145.2:5000/blog:v1
echo "${highlight}---------------------------------------------${NC}"
date
echo sync to github
echo "${highlight}---------------------------------------------${NC}"
time=$(date "+%Y-%m-%d %H:%M:%S")
echo ">>> please input your commit message !"
read message
git add .
git commit -m "${message}"
git push origin master
echo "${highlight}---------------------------------------------${NC}"

ssh shancw@serial.limiaomiao.site -p 11122 "sh /home/shancw/project/blog.sh"
echo deploy success!
echo "${highlight}---------------------------------------------${NC}"
exit 0