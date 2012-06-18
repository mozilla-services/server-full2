DEPS = https://github.com/mozilla-services/tokenserver,https://github.com/mozilla-services/server-syncstorage
VIRTUALENV = virtualenv
PYTHON = bin/python
NOSE = bin/nosetests -s
TESTS = deps/https:/github.com/mozilla-services/server-syncstorage/syncstorage/tests
BUILDAPP = bin/buildapp
BUILDRPMS = bin/buildrpms
PYPI = http://pypi.python.org/simple
PYPIOPTIONS = -i $(PYPI)
CHANNEL = dev
INSTALL = bin/pip install
INSTALLOPTIONS = -U -i $(PYPI)

ifdef PYPIEXTRAS
	PYPIOPTIONS += -e $(PYPIEXTRAS)
	INSTALLOPTIONS += -f $(PYPIEXTRAS)
endif

ifdef PYPISTRICT
	PYPIOPTIONS += -s
	ifdef PYPIEXTRAS
		HOST = `python -c "import urlparse; print urlparse.urlparse('$(PYPI)')[1] + ',' + urlparse.urlparse('$(PYPIEXTRAS)')[1]"`

	else
		HOST = `python -c "import urlparse; print urlparse.urlparse('$(PYPI)')[1]"`
	endif
	INSTALLOPTIONS += --install-option="--allow-hosts=$(HOST)"

endif

INSTALL += $(INSTALLOPTIONS)


.PHONY: all build update test


all:	build

build:
	$(VIRTUALENV) --no-site-packages --distribute .
	$(INSTALL) Distribute
	$(INSTALL) MoPyTools
	$(INSTALL) Nose
	$(BUILDAPP) -c $(CHANNEL) $(PYPIOPTIONS) $(DEPS)
	for DEP in `echo $(DEPS) | tr ',' ' '`; do $(INSTALL) -r ./deps/$$DEP/$(CHANNEL)-reqs.txt; done
	$(INSTALL) https://github.com/mozilla-services/mozservices/zipball/master

update:
	$(BUILDAPP) -c $(CHANNEL) $(PYPIOPTIONS) $(DEPS)

test:
	$(PYTHON) -c "import M2Crypto"
	$(NOSE) $(TESTS)
