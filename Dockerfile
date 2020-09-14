FROM python:3.8.3-slim-buster AS compile
COPY requirements.txt .
RUN apt update \
 && apt install --no-install-recommends -y ca-certificates git openssl \
 && apt install --no-install-recommends -y libffi-dev libssl-dev build-essential python3-pip python3-dev python2 make g++ \
 && apt install opencc pybind11-dev -y \
 && git clone https://github.com/google/re2.git \
 && cd re2 \
 && make \
 && make test \
 && make install \
 && make testinstall \
 && pip install --user -r requirements.txt

FROM python:3.8.3-slim-buster AS build
COPY . /app
RUN mkdir -p /app/data
WORKDIR /app
COPY --from=compile /root/.local /root/.local
CMD ["python3", "main.py"]
