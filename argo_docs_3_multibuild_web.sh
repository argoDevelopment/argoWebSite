kill -9 $(ps aux | grep '[j]ekyll' | awk '{print $2}')
clear

echo "Building argo_docs Writers website..."
jekyll build --config configs/doc/config_writers.yml
# jekyll serve --config configs/doc/config_writers.yml
echo "done"

echo "Building argo_docs Designers websote..."
jekyll build --config configs/doc/config_designers.yml
# jekyll serve --config configs/doc/config_designers.yml
echo "done"

echo "All finished building all the web outputs!!!"
echo "Now push the builds to the server with . argo_docs_4_publish.sh"

