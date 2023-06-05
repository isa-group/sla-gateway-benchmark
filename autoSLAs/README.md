# Auto-generate SLAs

The following generates 4 SLAs (2 of type _basic_ and 2 of type _pro_), each one with 2 API keys and places them at `../specs/slas/`:

```bash
SLAS_TO_PRODUCE=4 \
APIKEYS_PER_SLA=2 \
GENERATED_LOCATION=../specs/slas/ \
node index.js
```

Note `SLAS_TO_PRODUCE` must be an even integer as the code generates the same number of SLAs from each type, and there are two types: basic and pro. 
