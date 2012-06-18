# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
from setuptools import setup

install_requires = ['PasteScript', 'tokenserver', 'SyncStorage']

entry_points = """
[paste.app_factory]
main = syncserver2:make_app
"""

setup(name='SyncServer2', version="2.0", packages=['syncserver2'],
      install_requires=install_requires, entry_points=entry_points)
