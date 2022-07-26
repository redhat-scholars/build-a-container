#! /bin/bash
echo "userid set to "
echo $userid
read -p "Please run as root set variable userid=studentX for this script" -t 5
echo "Tidying up"
podman stop -a
podman rm -a
podman rmi -a

read -p "Running web server in a container" -t 2
podman run \
    --privileged \
    -d \
    -p 8081:80/tcp \
    --name my-web-server \
    quay.io/bfarr/container-workshop-httpd:0.0.6 

podman ps
read -p "Check Process is running and inserting an entry into visitor log" -t 2
curl http://localhost:8081/hello.html

curl http://localhost:8081/cgi-bin/log-visitor.sh?visitor=Danny

read -p "Checking host version of OS" -t 2

cat > /tmp/hostinfo.txt <<EOF
User Info:
---------
I am $(whoami)
$(id)

OS Version:
----------
$(cat /etc/os-release | head -4)

$(cat /etc/os-release | tail -4)

Processes:
---------
Total: $(ps -aux | wc -l)

$(ps -aux --sort pid | head -6)
EOF

/usr/lib/code-server/bin/code-server -r /tmp/hostinfo.txt

read -p "Checking host version of Container" -t 2
podman exec \
   my-web-server \
    ls

rm /home/$userid/container-workshop/visitor_info.txt

podman stop my-web-server 

podman ps

podman ps -a 

podman commit \
   my-web-server \
   container-workshop-commit 
read -p "Committed container checking images" -t 2
podman images

podman rm my-web-server

podman ps -a

podman run \
    --privileged \
    -d \
    -p 8081:80/tcp \
    --name my-web-server \
    quay.io/bfarr/container-workshop-httpd:0.0.6

podman cp \
  my-web-server:/var/log/www/visitor_info.txt \
  /home/$userid/container-workshop 


podman stop -a 
podman rm -a

podman run \
   --privileged \
   -d \
   -p 8081:80/tcp \
   --name my-web-server \
   localhost/container-workshop-commit 

podman cp \
  my-web-server:/var/log/www/visitor_info.txt \
  /home/$userid/container-workshop 

podman rm -a \
    --force 

podman rmi \
   localhost/container-workshop-commit 

podman run \
    --privileged \
    -d \
    -p 8081:80/tcp \
    --name my-web-server \
    -v /home/$userid/container-workshop:/var/log/www:Z \
    quay.io/bfarr/container-workshop-httpd:0.0.6


read -p "Test with volument mounted" -t 4

curl http://localhost:8081/hello.html

curl http://localhost:8081/cgi-bin/log-visitor.sh?visitor=Danny