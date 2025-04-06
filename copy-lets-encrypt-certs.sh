#!/bin/bash

source "$(dirname "$0")/command-failure.sh"

pathToLetsencryptDomainCertificates="$1"
domainName="$2"

if ! command -v rename &> /dev/null; then
    commandFailure "rename command not found. Please install it."
fi

if [ -z "$pathToLetsencryptDomainCertificates" ]; then
    commandFailure "Please provide the path to the letsencrypt domain certificates"
fi

if [ -z "$domainName" ]; then
    commandFailure "Please provide the domain name"
fi

if [ ! -d "${pathToLetsencryptDomainCertificates}/${domainName}" ]; then
    commandFailure "Directory ${pathToLetsencryptDomainCertificates}/${domainName} does not exist."
fi

rm -rf temp/certbot/${domainName}/
mkdir -p temp/certbot/${domainName}/
cp -R ${pathToLetsencryptDomainCertificates}/${domainName}/cert*.pem temp/certbot/${domainName}/

# put all file numbers into an array

rm cert-names
ls temp/certbot/${domainName}/ > cert-names
filenumbers=()
while read -r line; do
    filenumber=${line//[!0-9]/} || 0
    if [ "${filenumber}" == "" ]; then
        filenumber=0
    fi
    echo "filenumber '${filenumber}'"
    if [[ " ${filenumbers[@]} " =~ " ${filenumber} " ]]; then
       echo "file number already in array"
    else
        filenumbers+=( $filenumber )
    fi
done < cert-names

echo "filenumbers ${filenumbers[@]}"

# find max number in the array
max=0
for v in ${filenumbers[@]}; do
    if (( $v > $max )); then max=$v; fi;
done
echo $max

# remove files that aren't the max number
while read -r line; do
    filenumber=${line//[!0-9]/} || 0
    if [ "${filenumber}" == "" ]; then
        filenumber=0
    fi

    if [ "${filenumber}" -eq "${max}" ]; then
        echo "keeping this file '${line}'"
    else
        echo "deleting this file '${line}'"
        rm temp/certbot/${domainName}/${line}
    fi
done < cert-names

rename 's/\d+//' temp/certbot/${domainName}/*
