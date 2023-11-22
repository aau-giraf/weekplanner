# Brug det officielle Flutter-billede
FROM ubuntu:latest

# Installer nødvendige afhængigheder
RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils openjdk-11-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Installer Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

# Sørg for, at Flutter er opdateret
RUN flutter upgrade

# Installer Android SDK
RUN mkdir -p /opt/android-sdk && \
    curl -L https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -o /tmp/android-sdk.zip && \
    unzip -qq /tmp/android-sdk.zip -d /opt/android-sdk && \
    rm -f /tmp/android-sdk.zip

# Konfigurer Android SDK-miljøvariabler
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Accepter licensaftaler
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

# Sæt arbejdsområdet til /app
WORKDIR /app

# Kopier pubspec-filerne for at cache afhængigheder
COPY pubspec.yaml pubspec.lock /app/

# Installer appafhængigheder
RUN flutter pub get

# Kopier resten af appen til arbejdsområdet
COPY . /app/

# Byg Flutter-appen
RUN flutter build apk --release

# Eksekverbar kommando
CMD ["flutter", "run", "--release"]
