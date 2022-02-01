#!/bin/sh

# Install Stream package
dnf in centos-release-stream

# Swap the repos to Stream
dnf swap centos-linux-repos centos-stream-repos

# Sync the repos
dnf repolist
dnf distro-sync