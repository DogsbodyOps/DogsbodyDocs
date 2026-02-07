FROM httpd:2.4
COPY ./mkdocs/site/ /usr/local/apache2/htdocs/
