FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl git build-essential openjdk-21-jdk unzip gradle

ENV NVM_DIR=/root/.nvm

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Instalar node 20 y setear default
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 20 && nvm alias default 20"

ENV PATH=$NVM_DIR/versions/node/v20.*/bin:$PATH

RUN bash -c "source $NVM_DIR/nvm.sh && npm install -g @ionic/cli"

ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
  curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
  unzip commandlinetools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
  rm commandlinetools.zip && \
  mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest

RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses && \
  sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "platforms;android-33" "build-tools;33.0.2"

WORKDIR /app

CMD [ "bash" ]
