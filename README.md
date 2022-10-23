# ovh-dynhost-google-bash-update

A simple bash script to update dynhost record (requires curl binary)

## Install

Note: permissions are super important :

        cp authrc.example authrc
        chmod 640 domainrc
        cp domainrc.example domainrc
        chmod 600 authrc

Edit the following file according to your needs and your credentials :

        vim authrc domainrc
