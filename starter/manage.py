#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""

import os
import sys

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "starter.settings")
    os.environ.setdefault("DJANGO_CONFIGURATION", "Production")

    from configurations.management import execute_from_command_line

    execute_from_command_line(sys.argv)
