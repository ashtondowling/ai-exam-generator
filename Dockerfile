# Use Ubuntu so apt has a tectonic package
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive PYTHONUNBUFFERED=1

# OS deps: Python + Tectonic
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv \
      ca-certificates curl \
      tectonic \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

# Gunicorn: adjust target if you don't have a factory
CMD sh -lc 'gunicorn -w 2 -k gthread --threads 4 -b 0.0.0.0:$PORT "exam:website()"'
