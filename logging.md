# Python logging module
```python
level = os.getenv("LOGGING_LEVEL", "info").lower()
if level == "debug":
    level = logging.DEBUG
elif level == "info":
    level = logging.INFO
elif level == "warning":
    level = logging.WARNING
elif level == "error":
    level = logging.ERROR
elif level == "critical":
    level = logging.CRITICAL
else:
    level = logging.INFO

logging.root.handlers = []  # need this otherwise the log file might be empty. See: https://stackoverflow.com/questions/13733552/logger-configuration-to-log-to-file-and-print-to-stdout#comment104733919_46098711
logging.basicConfig(format='%(asctime)s.%(msecs)03d - %(levelname)s - %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S',
                    level=level,
                    handlers=[
                            logging.FileHandler("/path/to/logfile.log"),
                            logging.StreamHandler()
                    ])
```
