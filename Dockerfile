FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1

# Install tools, then fetch the prebuilt Tectonic binary (Linux x86_64)
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates xz-utils \
 && TECT_VER=0.15.0 \
 && curl -L -o /tmp/tectonic.tar.xz \
      https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic-$TECT_VER/tectonic-$TECT_VER-x86_64-unknown-linux-gnu.tar.xz \
 && mkdir -p /opt/tectonic \
 && tar -xJf /tmp/tectonic.tar.xz -C /opt/tectonic --strip-components=1 \
 && ln -s /opt/tectonic/tectonic /usr/local/bin/tectonic \
 && rm -rf /var/lib/apt/lists/* /tmp/tectonic.tar.xz

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# Bind to Render's $PORT and point Gunicorn at your app
CMD sh -lc 'gunicorn -w 2 -k gthread --threads 4 -b 0.0.0.0:$PORT "exam:website()"'
