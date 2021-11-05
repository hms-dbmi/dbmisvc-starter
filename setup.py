#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""dbmisvc-starter setup."""

import os
import re
from setuptools import setup, find_packages


def read_file(filename):
    """Read a file into a string."""
    path = os.path.abspath(os.path.dirname(__file__))
    filepath = os.path.join(path, filename)
    try:
        return open(filepath).read()
    except IOError:
        return ""


def get_readme():
    """Return the README file contents. Supports text,rst, and markdown."""
    for name in ("README", "README.rst", "README.md"):
        if os.path.exists(name):
            return read_file(name)
    return ""


def get_version(package):
    """Return package version as listed in `__version__` in `init.py`."""
    init_py = open(
        os.path.join(
            os.path.dirname(os.path.abspath(__file__)),
            os.path.join(package, "starter", "__init__.py"),
        )
    ).read()
    return re.search("__version__ = ['\"]([^'\"]+)['\"]", init_py).group(1)


DESC = "A starter application for a DBMI service"
setup(
    name="dbmisvc-starter",
    version=get_version("starter"),
    url="https://github.com/hms-dbmi/dbmisvc-starter",
    author="HMS DBMI - Techcore",
    author_email="bryan_larson@hms.harvard.edu",
    description=DESC,
    long_description=get_readme(),
    packages=find_packages(),
    include_package_data=True,
    classifiers=[
        "Framework :: Django",
    ],
)
