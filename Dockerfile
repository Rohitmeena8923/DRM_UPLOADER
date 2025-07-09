FROM python:3.11-slim-bullseye

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libffi-dev \
    libc6-dev \
    ffmpeg \
    aria2 \
    make \
    g++ \
    cmake \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/axiomatic-systems/Bento4/archive/v1.6.0-639.zip && \
    unzip v1.6.0-639.zip && \
    cd Bento4-1.6.0-639 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    cp mp4decrypt /usr/local/bin/ && \
    cd ../.. && \
    rm -rf Bento4-1.6.0-639 v1.6.0-639.zip

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

CMD ["sh", "-c", "gunicorn app:app & python3 main.py"]