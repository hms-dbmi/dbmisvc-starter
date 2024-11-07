"""
ASGI config for starter project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/3.2/howto/deployment/asgi/
"""

import os
import sys

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "starter.settings")
os.environ.setdefault("DJANGO_CONFIGURATION", "Production")

from configurations.management import execute_from_command_line

execute_from_command_line(sys.argv)
