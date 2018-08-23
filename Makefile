.PHONY: install uninstall docs

install:
	make uninstall
	-julia -e 'using Pkg; Pkg.clone(pwd()); Pkg.build("Canopy")'

uninstall:
	-julia -e 'using Pkg; Pkg.rm("Canopy")'

docs:
	cd docs; \
	julia make.jl

help:
	@echo "install    install the package"
	@echo "uninstall  remove the package"
	@echo "docs       generate the documentation"
