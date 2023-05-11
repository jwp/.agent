# Configuration for coercing tidy to hammer the tags.
force-output: yes
output-xml: no
output-bom: no
output-encoding: utf8
markup: yes
wrap: 0

# Disable tidy errors and warnings entirely as applications
# aren't likely interested in the level of detail tidy is often used for.
quiet: yes
show-errors: 0
show-warnings: no

lower-literals: yes
uppercase-tags: no
uppercase-attributes: no
hide-comments: yes
# omit-optional-tags: no
# fix-style-tags: yes
# merge-emphasis: no
bare: yes
fix-uri: yes
join-styles: no

indent: no
tidy-mark: no
# keep-tabs: no
# indent-with-tabs: yes

# Attribute control.
repeated-attributes: keep-last
# drop-proprietary-attributes: yes
