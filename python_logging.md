# Python log facility

```python
import logging,sys
logging.basicConfig(format='%(asctime)s.%(msecs)03d | %(module)s.py : %(message)s', 
                    stream=sys.stdout, 
                    level=logging.INFO,
                    datefmt='%Y-%m-%d %H:%M:%S')
log = logging.getLogger(__name__).info

# [...]

log(f"blalbalba {foobar} ...")
```
