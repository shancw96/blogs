highlight='\033[0;31m'
NC='\033[0m'
echo "${highlight}----------------building local file...   -----------------------------${NC}"
npm run build
echo "${highlight}----------------building docker image...  -----------------------------${NC}"
docker rmi --force 11.11.111.1:5000/blog:v1
docker build . -t 11.11.111.1:5000/blog:v1 --no-cache
echo "${highlight}----------------pushing docker image...   -----------------------------${NC}"
docker push 11.11.111.1:5000/blog:v1
echo "${highlight}----------------run remote deploy shell command -----------------------------${NC}"
ssh shancw@serial.limiaomiao.site -p 11122 "sh /home/shancw/project/blog.sh"

# docker create \
#   --name=jackett \
#   -e PUID=1000 \
#   -e PGID=1000 \
#   -e TZ=Asia/Shanghai \
#   -p 9117:9117 \
#   -v /home/shancw/data/jackett:/config \
#   --restart unless-stopped \
#   linuxserver/jackett

# docker create \
#   --name=sonarr \
#   -e PUID=1000 \
#   -e PGID=1000 \
#   -e TZ=Asia/Shanghai \
#   -p 8989:8989 \
#   -v /home/shancw/data/sonnar:/config \
#   -v /home/shancw/data/media:/media \
#   --restart unless-stopped \
#   linuxserver/sonarr:latest

#   docker create  \
#     --name=qbittorrentee  \
#     -e WEBUIPORT=8080  \
#     -e PUID=1026 \
#     -e PGID=100 \
#     -e TZ=Asia/Shanghai \
#     -p 6881:6881  \
#     -p 6881:6881/udp  \
#     -p 8080:8080  \
#     -v /home/shancw/data/qbittorrent:/config  \
#     -v /home/shancw/data/media:/downloads  \
#     --restart unless-stopped  \
#     superng6/qbittorrentee:latest

# version: "2.3"
# services:
#   emby:
#     image: emby/embyserver
#     container_name: embyserver
#     runtime: nvidia # Expose NVIDIA GPUs
#     network_mode: host # Enable DLNA and Wake-on-Lan
#     environment:
#       - UID=1000 # The UID to run emby as (default: 2)
#       - GID=100 # The GID to run emby as (default 2)
#       - GIDLIST=100 # A comma-separated list of additional GIDs to run emby as (default: 2)
#     volumes:
#       - /home/shancw/data/emby:/config # Configuration directory
#       - /home/shancw/data/media:/mnt/share1 # Media directory
#       - /home/shancw/data/media:/mnt/share2 # Media directory
#     ports:
#       - 8096:8096 # HTTP port
#       - 8920:8920 # HTTPS port
#     devices:
#       - /dev/dri:/dev/dri # VAAPI/NVDEC/NVENC render nodes
#       - /dev/vchiq:/dev/vchiq # MMAL/OMX on Raspberry Pi
#     restart: unless-stopped
# version: "3"
# services:
#   chinesesubfinder:
#     image: allanpk716/chinesesubfinder:latest
#     volumes:
#       - /home/shancw/data/chinesesubfinder/SubFixCache:/app/cache
#       - /home/shancw/data/chinesesubfinder:/config

#       - /home/shancw/data/media:/media
#     ports:
#       - "19035:19035"
#     environment:
#       - PUID=1026
#       - PGID=100
#       - TZ=Asia/Shanghai
#     restart: unless-stopped
#   export https_proxy=http://192.168.5.233:7890 http_proxy=http://192.168.5.233:7890 all_proxy=socks5://192.168.5.233:7890