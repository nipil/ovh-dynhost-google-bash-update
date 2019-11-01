#! /usr/bin/env bash

# test for curl
curl -V >/dev/null 2>&1 || { echo >&2 "I require CURL executable but it's not available in path. Aborting."; exit 1; }

# load configs
read AUTH < authrc || { echo >&2 "I require 'authrc' configuration file in current directory. Aborting."; exit 1; }
read DOMAIN < domainrc || { echo >&2 "I require 'domainrc' configuration file in current directory. Aborting."; exit 1; }

# get ipv4 from google
dig -4 txt +short o-o.myaddr.l.google.com @ns1.google.com | tr -d '"' > last-ipv4.txt || { echo >&2 "Could not get current external IPv4. Aborting."; exit 1; }
read IPV4 < last-ipv4.txt || { echo >&2 "I require 'domainrc' configuration file in current directory. Aborting."; exit 1; }

# update ovh dynhost record
curl -s -S --basic --user "${AUTH}" "https://www.ovh.com/nic/update?system=dyndns&hostname=${DOMAIN}&myip=${IPV4}" > last-result.txt || { echo >&2 "Could not update current external IPv4. Aborting."; exit 1; }

# check result, possible are :
#   nochg 2.3.4.5
#   good 3.4.5.6
#   !yours
#   Badfqdn
#   3.4.5.6.5 n'est pas une ip
read RESULT < last-result.txt
[[ "${RESULT}" =~ 'nochg ' || "${RESULT}" =~ 'good ' ]] || { echo >&2 "Something wrong happened calling the OVH DynHOST API. Aborting."; exit 1; }

# success
exit 0
