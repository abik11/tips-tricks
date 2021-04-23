## Redis

### Basic usage
* Starting redis server: `redis-server`
* Monitoring redis: `redis-cli monitor`
* Checking redis status: `redis-cli ping`
* Entering interactive mode: `redis-cli`

### Redis commands
* Check status: `ping`
* List all keys: `keys *`
* Get given key and check its value: `get key_name`
* Set key with given value: `set key_name key_value`
* Set expiration time for given key: `expire key_name 500`
* Check expiration time for given key: `ttl key_name`
