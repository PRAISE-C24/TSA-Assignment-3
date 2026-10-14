FROM ubuntu:alpine

# Install necessary networking and debugging utilities
RUN apt-get update && apt-get install -y \
    netcat \
    dnsutils \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy application files and make them executable
COPY app/ ./app/
RUN chmod +x ./app/app.sh

ENTRYPOINT ["./app/app.sh"]