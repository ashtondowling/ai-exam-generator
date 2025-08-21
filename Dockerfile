FROM python:3.12-slim-bookworm

ENV PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Debian/Bookworm package names (these match your failing log)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates \
    libgraphite2-3 libharfbuzz0b libfontconfig1 libfreetype6 \
    libjpeg62-turbo libpng16-16 libtiff6 libicu72 \
    tesseract-ocr tesseract-ocr-eng \
 && rm -rf /var/lib/apt/lists/*

# Install Tectonic
RUN curl -fsSL https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%400.15.0/tectonic-0.15.0-x86_64-unknown-linux-gnu.tar.gz \
  -o /tmp/tectonic.tar.gz \
 && tar -xzf /tmp/tectonic.tar.gz -C /usr/local/bin/ tectonic \
 && chmod +x /usr/local/bin/tectonic \
 && tectonic --version \
 && rm /tmp/tectonic.tar.gz

WORKDIR /app
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt

COPY . .

CMD sh -lc 'gunicorn -w 1 -k gthread --threads 4 -b 0.0.0.0:$PORT "exam:website()"'


