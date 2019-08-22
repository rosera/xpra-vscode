FROM debian:stretch-slim
MAINTAINER Rich Rose <askrichardrose@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y software-properties-common \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        --no-install-recommends

# Install XPRA
RUN curl https://winswitch.org/gpg.asc | apt-key add - && \
  echo "deb http://winswitch.org/ stretch main" > /etc/apt/sources.list.d/xpra.list && \
  apt-get update && \
  apt-get install -y xpra xvfb xterm && \
  apt-get clean && \ 
  rm -rf /var/lib/apt/lists/*


######## SAMPLE APPLICATION ##################
# Add VS Code
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | apt-key add -
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

RUN apt-get update && apt-get -y install \
        code \
        git \
        libasound2 \
        libatk1.0-0 \
        libcairo2 \
        libcups2 \
        libexpat1 \
        libfontconfig1 \
        libfreetype6 \
        libgtk2.0-0 \
        libpango-1.0-0 \
        libx11-xcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        openssh-client \
        --no-install-recommends \
        && rm -rf /var/lib/apt/lists/*

ADD vscode.sh /usr/local/bin/vscode
RUN chmod +x /usr/local/bin/vscode
######## SAMPLE APPLICATION ##################

#ENV HOME /home/user

# Add xpra tester account
RUN useradd --create-home --home-dir $HOME user \
  && chown -R user:user $HOME

# DISPLAY
ENV DISPLAY=:100

# Add a Data volume
VOLUME /data

WORKDIR /data

# Container Port
#EXPOSE 10000
EXPOSE 8080

# USER
USER user

# CMD to execute
#CMD xpra start --bind-tcp=0.0.0.0:10000 --html=on --exit-with-children --daemon=no --xvfb="/usr/bin/Xvfb +extension  Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no --start-child=vscode
CMD xpra start --bind-tcp=0.0.0.0:8080 --html=on --exit-with-children --daemon=no --xvfb="/usr/bin/Xvfb +extension  Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no --start-child=vscode
