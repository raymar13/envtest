FROM ubuntu:latest

# No input in the prompt
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y upgrade

# Install python dependencies
RUN apt-get install -y \
    build-essential \
    libssl-dev\
    libffi-dev \ 
    python3-dev \
    python3-pip \
    curl \
    unixodbc-dev \
    alien

# Change Aliases
RUN cd "$(dirname $(which python3))" \
    && ln -s python3 python \
    && ln -s pip3 pip

WORKDIR /drivers
COPY ./drivers .
RUN alien --to-deb dremio-odbc-1.5.1.1001-1.x86_64.rpm \
  && dpkg -i dremio-odbc_1.5.1.1001-2_amd64.deb
ENV PATH ${PATH}:/drivers
# Install nodejs
# RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
#   apt-get upgrade -y && \
#   apt-get install -y nodejs texlive-latex-extra texlive-xetex && \
#   rm -rf /var/lib/apt/lists/* && \
#   node -v
# RUN apt install -y nodejs npm

WORKDIR /home

COPY requirements.txt .

RUN pip install -r requirements.txt

# RUN jupyter labextension install @jupyterlab/toc \
#     && jupyter lab build

EXPOSE 8888