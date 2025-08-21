FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1

# tools + fetch latest tectonic binary for Linux x86_64
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates xz-utils jq \
 && url=$(curl -fsSL https://api.github.com/repos/tectonic-typesetting/tectonic/releases/latest \
       | jq -r '.assets[] | select(.name | test("x86_64-unknown-linux-gnu.tar.(xz|gz)$")) | .browser_download_url' | head -n1) \
 && echo "Downloading $url" \
 && curl -fsSL "$url" -o /tmp/tectonic.tar \
 && mkdir -p /opt/tectonic \
 && if echo "$url" | grep -q '\.xz$'; then tar -xJf /tmp/tectonic.tar -C /opt/tectonic --strip-components=1; else tar -xzf /tmp/tectonic.tar -C /opt/tectonic --strip-components=1; fi \
 && chmod +x /opt/tectonic/tectonic \
 && ln -s /opt/tectonic/tectonic /usr/local/bin/tectonic \
 && tectonic --version \
 && rm -rf /var/lib/apt/lists/* /tmp/tectonic.tar

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

CMD sh -lc 'gunicorn -w 2 -k gthread --threads 4 -b 0.0.0.0:$PORT "exam:website()"'
