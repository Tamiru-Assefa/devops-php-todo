#Base Image: We use the apache php installed from dockerhub
FROM php:8.2-apache

#Copy the app files to the apache folder
COPY ./app /var/www/html

#Exposing the image to port 80(HTTP)
EXPOSE 80