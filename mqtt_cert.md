# Mqtt ca, cert, ...
```
+------------------------------------------------------------+
|                   Private Certificate Authority            |
|                        (Your Root of Trust)                |
|                                                            |
|                          [SECRET] 🔑           [PUBLIC] 📜     |
| openssl --(generate)-->  ca.key  ---(generates)---> ca.crt |
+------------------------------|-----------------------------+
                               |
            (Uses ca.key to SIGN certificate requests)
                               |
          .--------------------'--------------------.
          |                                         |
          v                                         v
+--------------------------------+         +--------------------------------+
|    MQTT Broker (Server)        |         |      MQTT Client               |
|--------------------------------|         |--------------------------------|
|                                |         |                                |
|  1. Generate `server.key`      |         |  1. Generate `client.key`      |
|     (SECRET 🔑)                  |         |     (SECRET 🔑)                  |
|          |                     |         |          |                     |
|          v                     |         |          v                     |
|  2. Create `server.csr`        |         |  2. Create `client.csr`        |
|     (Sent to CA to be signed)  |         |     (Sent to CA to be signed)  |
|          |                     |         |          |                     |
|          v                     |         |          v                     |
|  3. Receive `server.crt`       |         |  3. Receive `client.crt`       |
|     (PUBLIC📜, signed by ca.key) |         |     (PUBLIC, signed by ca.key) |
|                                |         |                                |
|--------------------------------|         |--------------------------------|
| Files required to operate:     |         | Files required to operate:     |
| - ca.crt   (to verify clients) |         |  - ca.crt   (to verify server) |
| - server.crt (its public ID)   |         |  - client.crt (its public ID)  |
| - server.key (its secret ID)   |         |  - client.key (its secret ID)  |
+--------------------------------+         +--------------------------------+
```

# Delegated trust model
Advantage compare to Direct trust model (ssh with authorized_keys): scalability. 
- To allow new user to the mqtt server, the CA authority can generate new keys and give to new clients, while there are no change needed from the mqtt server side. 
- In comparison with ssh, each new client addition require adding a public key to the server. Making change on server is not scalable/desirable.  

<img width="3162" height="2826" alt="mqtt_cert_files" src="https://github.com/user-attachments/assets/5588cbc4-84f1-4c46-bcd3-01ab6a9048f1" />
