# This is a common snippet to be inserted into other modules to enforce a
# docstring style. Do not use it as a module.

using DocStringExtensions

@template DEFAULT =
    """
    $(SIGNATURES)

    $(DOCSTRING)
    """
