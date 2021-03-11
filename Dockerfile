#Stage 1 - Install dependencies and build the app
FROM debian:latest AS build-env

# Install flutter dependencies
RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

# Clone the flutter repo
RUN git clone -b '1.25.0-8.3.pre' --single-branch https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
# RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter config --enable-web

# Copy files to container and build
# RUN mkdir /app/
WORKDIR /app 
COPY . .
RUN flutter pub get
RUN flutter build web 

# Stage 2 - Create the run-time image
FROM nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html
