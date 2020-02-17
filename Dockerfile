FROM node:13

WORKDIR /usr/src/rn

ARG SDK_VERSION=sdk-tools-linux-4333796.zip
ARG ANDROID_BUILD_VERSION=29
ARG ANDROID_TOOLS_VERSION=29.0.2
ARG NDK_VERSION=20

ENV ANDROID_HOME=/opt/android
ENV ANDROID_SDK_HOME=${ANDROID_HOME}
ENV ANDROID_NDK=/opt/ndk/android-ndk-r$NDK_VERSION

ENV PATH=${ANDROID_NDK}:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:/opt/buck/bin/:${PATH}

# install JDK
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    openjdk-8-jdk-headless

# install NDK
RUN curl -sS https://dl.google.com/android/repository/android-ndk-r$NDK_VERSION-linux-x86_64.zip -o /tmp/ndk.zip \
    && mkdir /opt/ndk \
    && unzip -q -d /opt/ndk /tmp/ndk.zip \
    && rm /tmp/ndk.zip

# install SDK
RUN curl -sS https://dl.google.com/android/repository/${SDK_VERSION} -o /tmp/sdk.zip \
     && mkdir ${ANDROID_HOME} \
     && unzip -q -d ${ANDROID_HOME} /tmp/sdk.zip \
     && rm /tmp/sdk.zip \
     && yes | sdkmanager --licenses \
     && yes | sdkmanager "platform-tools" \
         "emulator" \
         "platforms;android-28" \
         "platforms;android-$ANDROID_BUILD_VERSION" \
         "build-tools;28.0.3" \
         "build-tools;$ANDROID_TOOLS_VERSION" \
         "add-ons;addon-google_apis-google-23" \
         "system-images;android-19;google_apis;armeabi-v7a" \
         "extras;android;m2repository" \
     && rm -rf /opt/android/.android
