.PHONY: install uninstall test docs

install:
	make uninstall
	-julia -e 'using Pkg; Pkg.add(PackageSpec(path="."))'

uninstall:
	-julia -e 'using Pkg; Pkg.rm("Canopy")'

test:
	-julia test/runtests.jl

docs:
	cd docs; \
	julia make.jl

help:
	@echo "install    install the package"
	@echo "uninstall  remove the package"
	@echo "docs       generate the documentation"
