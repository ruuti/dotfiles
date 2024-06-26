brew-install:
	brew bundle --file=$(PWD)/Brewfile

brew-dump:
	brew bundle dump --file $(PWD)/Brewfile --force

scripts-install:
	cd scripts/go && go install
