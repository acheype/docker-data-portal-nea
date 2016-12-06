#/bin/bash
docker stop webdav
docker rm webdav
docker build -t acheype/httpd-webdav:latest .
docker run --restart="always" --name "webdav" -p 80:80 -d -t -v /data/webdav:/var/webdav acheype/httpd-webdav
