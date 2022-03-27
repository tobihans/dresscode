FROM gitpod/workspace-full:latest

ENV ANDROID_HOME=/home/gitpod/android-sdk \
    FLUTTER_HOME=/home/gitpod/flutter

USER root

RUN apt-get update && \
    apt-get -y install build-essential libkrb5-dev gcc make gradle openjdk-8-jdk && \
    apt-get clean && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*;

USER gitpod

RUN cd /home/gitpod && \
    git clone https://github.com/flutter/flutter.git -b stable /home/gitpod/flutter

RUN mkdir -p /home/gitpod/android-sdk && \
    cd /home/gitpod/android-sdk && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip && \
    unzip commandlinetools-linux-8092744_latest.zip && \
    rm -f commandlinetools-linux-8092744_latest.zip && \
    mv ~/android-sdk/cmdline-tools/ latest && \
    mkdir -p ~/android-sdk/cmdline-tools/ && \
    mv latest ~/android-sdk/cmdline-tools/
