
docker build . -t 192.168.193.72:5000/blog-static:latest --no-cache
echo "---------------------------"
echo ">> start pushing image to 192.168.193.72:5000"
docker push 192.168.193.72:5000/blog-static:latest
echo ">> image push success"
