#! /bin/bash

# Change permissions for files copied over from NTFS
sudo find -type d -exec chmod 755 {} \;
sudo find -type f -exec chmod 644 {} \;
# Also desktop.ini are annoying
sudo find -name desktop.ini -exec rm {} \;

