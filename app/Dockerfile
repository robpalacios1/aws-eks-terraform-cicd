# Use lite image from nginx based in Alpine Linux
FROM nginx:alpine

# Copy the HTML to public folder of Nginx
COPY index.html /usr/share/nginx/html/index.html

# Expose port
EXPOSE 80

# Run Nginx when server turn on
CMD [ "nginx", "-g", "daemon off;" ]