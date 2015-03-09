# Hostname lookups

If we have ACLs like "Allow .example.com", we also need `HostNameLookups On`.
This should be automatically detected instead of an explicit attribute.

# cupsctl

cupsctl alters cupsd.conf which will be overwritten by chef.
Either make cupsctl read-only or preserve its modifications.
Same is true for the server settings panel in the web interface.
