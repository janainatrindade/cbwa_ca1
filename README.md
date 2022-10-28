## Usage

If the image is hosted in your machine you should access the directory where the dockerfile is.
````
cd /Desktop/Image
````

Inside the directory build the image
````
docker build -t static-website .
````
Run the image
````
docker run -it --rm -p 8080:8080 static-website
````
And finally you can access in the browser
````
http://localhost:8080
````


## References 
Florin Lipan. (2021). The smallest Docker image to serve static websites. [online] Available at: https://lipanski.com/posts/smallest-docker-image-static-website.
‌
