!#/bin/bash

git add .
git commit -am @a
git push origin master

ssh bcndw 'cd /var/www/j.tmpo.io/ && git pull origin master'
