LEKTOR_SERVER_FLAGS=-h 127.0.0.1
# minify javascript assets, compile scss assets
LEKTOR_PLUGIN_FLAGS=-f scss -f pretifyhtml
LEKTOR_DEPLOY_FLAGS=

all: build

.ONESHELL:
install:
	if hash apt-get 2>/dev/null; then
	  apt-get update -qq >/dev/null && apt-get install -qq apt-utils imagemagick python3-pip python3-setuptools gcc git-lfs
	elif hash pacman 2>/dev/null; then
	  pacman -Syu imagemagick python-pip glibc lib32-glibc gcc git-lfs --noconfirm
	elif hash dnf 2>/dev/null; then
	  dnf install -y ImageMagick python3-pip gcc git-lfs
	else
	  echo -e "Please install Imagemagick, python3-pip git-lfs and gcc"
	fi
	pip3 install wheel  --upgrade
	pip3 install lektor --upgrade

build:
	if python3 -m lektor --version 2>/dev/null; then
	  python3 -m lektor build $(LEKTOR_PLUGIN_FLAGS)
	else
	  lektor build $(LEKTOR_PLUGIN_FLAGS)
	fi

server:
	if python3 -m lektor --version 2>/dev/null; then
	  python3 -m lektor server $(LEKTOR_SERVER_FLAGS) $(LEKTOR_PLUGIN_FLAGS)
	else
	  lektor server $(LEKTOR_SERVER_FLAGS) $(LEKTOR_PLUGIN_FLAGS)
	fi

deploy:
	lektor clean --yes
	lektor plugin flush-cache
	lektor build $(LEKTOR_PLUGIN_FLAGS) $(LEKTOR_DEPLOY_FLAGS)
	lektor deploy $(LEKTOR_PLUGIN_FLAGS) $(LEKTOR_DEPLOY_FLAGS)
