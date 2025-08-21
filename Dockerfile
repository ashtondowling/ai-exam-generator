FROM python:3.12-slim

# OS packages (tectonic lives in Debian/Ubuntu repos)
RUN apt-get update \
 && apt-get install -y --no-install-recommends tectonic \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# replace the CMD in your Dockerfile with this shell form so $PORT works
CMD sh -lc 'gunicorn -w 2 -k gthread --threads 4 -b 0.0.0.0:$PORT "exam:website()"'

