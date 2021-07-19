FROM python:3.6-alpine3.11 AS builder

# Install dependencies
RUN apk add --update \
    build-base \
    g++ \
    libffi-dev \
    mariadb-dev

# Add requirements
ADD requirements.txt /requirements.txt

# Use this until we can safely update to Alpine 3.13 or above
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1

# Install Python packages
RUN pip install -r /requirements.txt

FROM hmsdbmitc/dbmisvc:alpine-python3.6-0.1.0

RUN apk add --no-cache --update \
    mariadb-connector-c \
  && rm -rf /var/cache/apk/*

# Copy pip packages from builder
COPY --from=builder /root/.cache /root/.cache

# Add requirements
ADD requirements.txt /requirements.txt

# Install Python packages
RUN pip install -r /requirements.txt

# Copy app source
COPY /starter /app

# Set the build env
ENV DBMI_ENV=prod

# Set app parameters
ENV DBMI_PARAMETER_STORE_PREFIX=
ENV DBMI_PARAMETER_STORE_PRIORITY=true
ENV DBMI_AWS_REGION=us-east-1

ENV DBMI_APP_WSGI=starter
ENV DBMI_APP_ROOT=/app
ENV DBMI_APP_DB=true
ENV DBMI_APP_DOMAIN=starter.dbmi.hms.harvard.edu

# Static files
ENV DBMI_STATIC_FILES=true
ENV DBMI_APP_STATIC_URL_PATH=/static
ENV DBMI_APP_STATIC_ROOT=/var/www/static

# Set nginx and network parameters
ENV DBMI_PORT=443
ENV DBMI_LB=true
ENV DBMI_SSL=true
ENV DBMI_CREATE_SSL=true
ENV DBMI_HEALTHCHECK=true
