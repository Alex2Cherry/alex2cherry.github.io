#!/bin/sh

git add .
git commit -am "Post a blog."
git push origin source
rake deploy
