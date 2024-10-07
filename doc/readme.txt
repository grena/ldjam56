
Pour faire ou refaire le build web

Suivre ce tuto pour installer l'export template web https://www.youtube.com/watch?v=y_YAKzlEbxs

Puis, project > export. Add Web preset

Puis, export project

Important, on exporte dans le folder ./web, le fichier exporter doit s'appeler index.html (par défaut, il s'appelle comme le projet, aka ldjam56.html)


Pour tester en local 

sudo apt-get install npm

puis lancer

nico@laptop:~/git/ldjam56/web$ npx local-web-server --https --cors.embedder-policy "require-corp" --cors.opener-policy "same-origin" --directory "."

puis ouvrir https://127.0.0.1:8000/
