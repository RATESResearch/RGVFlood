eval `ssh-agent -s`
#ssh-add /srv/RGVFlood/.ssh/deploykey
ssh-add ~/.ssh/id_rsa
COMPOSE_DOCKER_CLI_BUILD=1
DOCKER_BUILDKIT=1
BUILDKIT_PROGRESS=plain
docker-compose down -v
docker-compose up -d
sleep 1m
docker exec django4rgvflood sh -c "mkdir -p -m 0600 ~/.ssh"
docker exec django4rgvflood sh -c "ssh-keyscan -H github.com bitbucket.org >> ~/.ssh/known_hosts"
docker cp ../.ssh/deploykey django4rgvflood:/root/.ssh/
docker exec django4rgvflood sh -c "pip install git+ssh://git@github.com/RATESResearch/REONapp"
#docker exec django4rgvflood sh -c "pip install fontawesome-free"
docker cp base.html django4rgvflood:/usr/src/geonode/geonode/templates/
docker cp urls.py django4rgvflood:/usr/src/geonode/geonode/
docker cp settings.py django4rgvflood:/usr/src/geonode/geonode/
#docker exec django4rgvflood sh -c 'ls -alh /usr/local/lib/python3.8/site-packages/rths/'
docker exec django4rgvflood sh -c "python manage.py makemigrations --noinput"
docker exec django4rgvflood sh -c "python manage.py migrate --noinput"
docker cp theme.json django4rgvflood:/usr/src/geonode/    
docker exec django4rgvflood sh -c "mkdir -p /mnt/volumes/statics/uploaded/img/2021/12/"
docker cp background.jpg django4rgvflood:/mnt/volumes/statics/uploaded/img/2021/12/
docker cp logo.png django4rgvflood:/mnt/volumes/statics/uploaded/img/2021/12/
docker exec django4rgvflood sh -c "python manage.py loaddata /usr/src/geonode/theme.json"
docker exec django4rgvflood sh -c "python manage.py collectstatic --noinput"
docker exec django4rgvflood sh -c "touch /usr/src/geonode/geonode/wsgi.py           "