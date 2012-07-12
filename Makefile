DEPS = https://github.com/mozilla-services/tokenserver,https://github.com/mozilla-services/server-syncstorage
VIRTUALENV = virtualenv
PYTHON = bin/python
NOSE = bin/nosetests -s
TESTS = deps/server-syncstorage/syncstorage/tests
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
	$(INSTALL) https://github.com/mozilla/PyBrowserID/zipball/badbf3158c1cb371982f369368613d0f6a409396
	$(BUILDAPP) -c $(CHANNEL) $(PYPIOPTIONS) $(DEPS)

update:
	$(BUILDAPP) -c $(CHANNEL) $(PYPIOPTIONS) $(DEPS)

test:
	$(NOSE) $(TESTS)

clean:
	rm -rf bin lib lib64 man include deps
