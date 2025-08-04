ARG DBMISVC_IMAGE=hmsdbmitc/dbmisvc:debian12-slim-python3.12-0.7.1

FROM ${DBMISVC_IMAGE} AS builder

# Install requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        bzip2 \
        gcc \
        default-libmysqlclient-dev \
        libssl-dev \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Add requirements
ADD requirements.* /

# Build Python wheels with hash checking
RUN pip install -U wheel \
    && pip wheel -r /requirements.txt \
        --wheel-dir=/root/wheels

FROM ${DBMISVC_IMAGE}

ARG APP_NAME="dbmisvc-starter"
ARG APP_CODENAME="dbmisvc-starter"
ARG VERSION
ARG COMMIT
ARG DATE

LABEL org.label-schema.schema-version=1.0 \
    org.label-schema.vendor="HMS-DBMI" \
    org.label-schema.version=${VERSION} \
    org.label-schema.name=${APP_NAME} \
    org.label-schema.build-date=${DATE} \
    org.label-schema.description="DBMISVC Starter" \
    org.label-schema.url="https://github.com/hms-dbmi/dbmisvc-starter" \
    org.label-schema.vcs-url="https://github.com/hms-dbmi/dbmisvc-starter" \
    org.label-schema.vcf-ref=${COMMIT}

# Copy Python wheels from builder
COPY --from=builder /root/wheels /root/wheels

# Install requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        default-libmysqlclient-dev \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Add requirements files
ADD requirements.* /

# Install Python packages from wheels
RUN pip install --no-index \
        --find-links=/root/wheels \
        --force-reinstall \
        # Use requirements without hashes to allow using wheels.
        # For some reason the hashes of the wheels change between stages
        # and Pip errors out on the mismatches.
        -r /requirements.in

# Setup entry scripts
ADD docker-entrypoint-init.d/* /docker-entrypoint-init.d/

# Copy app source
COPY /starter /app

# Set the build env
ENV DBMI_ENV=prod

# Set app parameters
ENV DBMI_PARAMETER_STORE_PREFIX=
ENV DBMI_PARAMETER_STORE_PRIORITY=true
ENV DBMI_SECRETS_MANAGER_PRIORITY=true
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

# Django configurations
ENV DJANGO_CONFIGURATION=Production
ENV DJANGO_SETTINGS_MODULE=starter.settings
