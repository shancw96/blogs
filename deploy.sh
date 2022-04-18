highlight='\033[0;31m'
NC='\033[0m'
echo "${highlight}---------------------------------------------${NC}"

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
docker rmi --force 11.12.123.2:5000/blog:v1
docker build . -t 11.12.123.2:5000/blog:v1 --no-cache
echo "${highlight}---------------------------------------------${NC}"
date
echo pushing docker image...
echo "${highlight}---------------------------------------------${NC}"

docker push 11.12.123.2:5000/blog:v1
echo "${highlight}---------------------------------------------${NC}"
ssh shancw@serial.limiaomiao.site -p 11122 "sh /home/shancw/project/blog.sh"
