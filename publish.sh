#!/bin/bash

git add .
git commit -am $1
git push origin master

ssh bcndw 'cd /var/www/j.tmpo.io/ && git pull origin master'
