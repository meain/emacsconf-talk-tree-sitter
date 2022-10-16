# maybe self thing???
def _find_impl(cls, registry):
    """Returns the best matching implementation from *registry* for type *cls*.
    Where there is no registered implementation for a specific type, its method
    resolution order is used to find a more generic implementation.
    Note: if *registry* does not contain an implementation for the base
    *object* type, this function may return None.
    """
    mro = _compose_mro(cls, registry.keys())
    match = None
    for t in mro:
        if match is not None:
            # If *match* is an implicit ABC but there is another unrelated,
            # equally matching implicit ABC, refuse the temptation to guess.
            if (t in registry and t not in cls.__mro__
                              and match not in cls.__mro__
                              and not issubclass(match, t)):
                raise RuntimeError("Ambiguous dispatch: {} or {}".format(
                    match, t))
            break
        if t in registry:
            match = t
    return registry.get(match)