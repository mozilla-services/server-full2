# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
"""
Application entry point.
"""
import os
from logging.config import fileConfig
from ConfigParser import NoSectionError
from paste.deploy import loadapp

# Set the egg cache to a place where the webserver can write
os.environ['PYTHON_EGG_CACHE'] = '/tmp/python-eggs'

# Load the .ini file from production place, unless specified in environment.

ini_file = os.path.join(os.path.dirname(__file__),
                        '..', 'etc', 'production.ini')
ini_file = os.path.abspath(os.environ.get('SYNCSERVER2_INI_FILE', ini_file))

# Set up logging from the config file.
try:
    fileConfig(ini_file)
except NoSectionError:
    pass

# Load the application callable using paste.
application = loadapp('config:%s' % ini_file)
