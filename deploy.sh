highlight='\033[0;31m'
NC='\033[0m'
echo "${highlight}----------------building local file...   -----------------------------${NC}"
npm run build
echo "${highlight}----------------building docker image...  -----------------------------${NC}"
image_name=127.0.0.1:5000/blog:v1
docker rm blog
docker rmi $image_name
docker rm -f blog
docker build . -t $image_name --no-cache
echo "${highlight}----------------run docker image...  -----------------------------${NC}"
docker run -d -t -p 80:80 --name=blog --restart=always $image_name