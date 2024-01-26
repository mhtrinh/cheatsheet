`.pem` and `.crt` file seems to be the same format

You can create bundle by simply concatenating crt files

`REQUESTS_CA_BUNDLE` env variable tell python `requests` to use Zscaler certificate by pointing it to Zscaler Root CA crt (or pem) file. But if your program connect to multi end point 
and some is Zscalered and some are whitelisted, then you need several certificates ! The solution seems to be creating your own bundle by concat all certificate in `/etc/ssl/certs` and Zscaler one. 
Then use `REQUESTS_CA_BUNDLE` to that custom bundle file. 

`REQUESTS_CA_BUNDLE` also support path to folder ! But the effect is not completely the same. I  found some case (ClearML + Lakefs) where the bundle work but not the folder approach
