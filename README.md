For using this script you need to setup a smtp client
For exemple you can use msmtp
    sudo apt install msmtp msmtp-mta
    sudo apt install mailutils
    vim /etc/msmtprc :
        # Valeurs par défaut pour tous les comptes.
        defaults
        auth           on
        tls            on
        tls_starttls   on
        tls_trust_file /etc/ssl/certs/ca-certificates.crt
        logfile        /var/log/msmtp

        # Gandi
        account        gandi
        host           mail.gandi.net
        port           587
        from           xxxxxxx
        user           xxxxxxx
        password       xxxxxxx

        # Définir le compte par défaut
        account default : gandi
