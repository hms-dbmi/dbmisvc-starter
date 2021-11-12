"""
ASGI config for starter project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/3.2/howto/deployment/asgi/
"""

import os

# Install django-configurations importer
from configurations.importer import install

install(check_options=True)

from django.core.asgi import get_asgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "starter.settings")
os.environ.setdefault("DJANGO_CONFIGURATION", "Production")

application = get_asgi_application()
