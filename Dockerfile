FROM ubuntu:22.04
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3.12 and system dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
        python3.12 python3.12-pip python3.12-venv python3.12-dev \
        curl ca-certificates \
        libfontconfig1 libfreetype6 libgraphite2-3 libharfbuzz0b \
        libpng16-16 libjpeg8 libtiff5 && \
    rm -rf /var/lib/apt/lists/*

# Set Python 3.12 as default
RUN ln -sf /usr/bin/python3.12 /usr/bin/python && \
    ln -sf /usr/bin/python3.12 /usr/bin/python3 && \
    python -m ensurepip --upgrade

# Install tectonic
RUN curl -fsSL https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%400.15.0/tectonic-0.15.0-x86_64-unknown-linux-gnu.tar.gz \
    -o /tmp/tectonic.tar.gz && \
    tar -xzf /tmp/tectonic.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/tectonic && \
    tectonic --version && \
    rm /tmp/tectonic.tar.gz

WORKDIR /app
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt
COPY . .

CMD sh -lc 'gunicorn -w 2 -k gthread --threads 4 -b 0.0.0.0:$PORT "exam:website()"'
