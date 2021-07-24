echo ">> start building image..."
docker rmi --force 192.168.193.72:5000/blog:latest
docker build . -t 192.168.193.72:5000/blog:latest --no-cache
echo "---------------------------"
echo ">> start pushing image to 192.168.193.72:5000"
docker push 192.168.193.72:5000/blog:latest
echo ">> image push success"
echo ">> sync code to github and trigger git hook!"
echo "auto deploy" >> deploy.tag
git add . && git commit -m "docker deploy"
git push origin master
