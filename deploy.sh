echo ">> start building image..."
docker build -t blogs:latest .
echo ">> image build success"
echo "---------------------------"
echo ">> start pushing image to 192.168.193.72:5000"
docker push 192.168.193.72:5000/blog:test
echo ">> image push success"
echo ">> sync code to github and trigger git hook!"
echo "auto deploy" >> deploy.tag
git add . && git commit -m "docker deploy"
git push origin master
