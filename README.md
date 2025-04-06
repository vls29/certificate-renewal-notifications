# certificate-renewal-notifications

`./copy-lets-encrypt-certs.sh ~/certbot/config/archive example.com`

`./certificate-expiry-notification.sh temp/certbot/example.com/cert.pem`

Add to crontab, e.g.

`5 2 * * * /path/to/certificate-renewal-notifications/certificate-expiry-notification.sh /path/to/certificate-renewal-notifications/temp/certbot/example.com/cert.pem`