date
echo building local static file...
npm run build
date
echo building docker image...
docker rmi --force 192.168.193.72:5000/blog:latest
docker build . -t 192.168.193.72:5000/blog:latest --no-cache
date
echo pushing docker image...
docker push 192.168.193.72:5000/blog:latest
date
echo sync to github
git add . && git commit -m "docker auto deploy"
git push origin master
date
echo deploy success!
exit 0