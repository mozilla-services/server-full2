VIRTUALENV = virtualenv
NOSE = local/bin/nosetests -s
TESTS = syncstorage/tests
PYTHON = local/bin/python
PIP = local/bin/pip
PIP_CACHE = /tmp/pip-cache.${USER}
BUILD_TMP = /tmp/syncstorage-build.${USER}
PYPI = https://pypi.python.org/simple
INSTALL = $(PIP) install -U -i $(PYPI)

.PHONY: all build

all:	build

build:
	$(VIRTUALENV) --no-site-packages --distribute ./local
	$(INSTALL) Distribute
	$(INSTALL) pip
	$(INSTALL) nose
	$(INSTALL) flake8
	$(INSTALL) -r requirements.txt
	$(PYTHON) ./setup.py develop

serve:
	./local/bin/pserve etc/production.ini

clean:
	rm -rf ./local
