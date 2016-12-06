#!/bin/bash
echo "Content-type: text/html"
echo ''
cd /home/hugo
echo '<h2>Publishing the hugo website...<h2><br>'
echo '<br>Update the git local repository<br>' 
echo `git pull`
echo '<br><br>Build again the website<br>' 
echo `hugo`
chown 33:33 * -R
