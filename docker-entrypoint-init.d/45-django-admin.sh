#!/bin/bash -e

# Create an admin user (uses DJANGO_SUPERUSER_* environment variables)
python ${DBMI_APP_ROOT}/manage.py createsuperuser --no-input
