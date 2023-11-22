# Docker image for building Flutter app for Android and iOS
FROM ubuntu:latest

# Set the environment variables
ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH="$PATH:$ANDROID_HOME/tools"
ENV FLUTTER_HOME="/flutter"
ENV PATH="$PATH:$FLUTTER_HOME/bin"

# Update and install necessary tools
RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils openjdk-11-jdk libxml2-utils sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone Flutter repository
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME

# Upgrade Flutter
RUN $FLUTTER_HOME/bin/flutter upgrade

# Download and extract Android SDK
RUN mkdir -p $ANDROID_HOME && \
    curl -L https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -o /tmp/android-sdk.zip && \
    unzip /tmp/android-sdk.zip -d $ANDROID_HOME && \
    rm /tmp/android-sdk.zip

# Accept Android SDK licenses
RUN mkdir -p $ANDROID_HOME/licenses/ && \
    echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license && \
    yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --licenses

# Set working directory to /app
WORKDIR /app

# Add a non-root user
RUN groupadd -r nonroot && useradd -r -g nonroot -m nonroot

# Change ownership of the Flutter directory
RUN chown -R nonroot:nonroot /flutter

# Copy the rest of the application code to the container
COPY . /app/

# Change ownership of necessary directories
RUN chown -R nonroot:nonroot /app/
# Switch to the nonroot user
USER nonroot

# Get Flutter dependencies
RUN flutter pub get

# Check for outdated dependencies
RUN flutter pub outdated

USER root
# Fix permissions for .flutter-plugins-dependencies
RUN sudo chown -R nonroot:nonroot /app/.flutter-plugins-dependencies



# Sæt miljøvariablen for Android SDK# Sæt miljøvariablen for Android SDK
ENV ANDROID_SDK_ROOT="/opt/android-sdk"

# Opret mappen til Android SDK og tildel rettigheder
RUN mkdir -p $ANDROID_SDK_ROOT && \
    chown -R nonroot:nonroot $ANDROID_SDK_ROOT

# Installer de påkrævede Android SDK-komponenter
RUN yes | /opt/android-sdk/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses
RUN /opt/android-sdk/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platforms;android-31" "build-tools;30.0.3"

USER nonroot

# Build Flutter app for release
RUN flutter build apk --release

# Build iOS app for release
RUN flutter build ios --release
