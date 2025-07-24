## Papertrail

### Filter logs
```
("machine1" OR "machine15") severity:(error warn) (searched phrase OR other searched phrase) -("skip this" OR "this too")
```
### Filter machines by name
Filtr out machines/programs that have `dev` in their name, so for example `machine1` will be included in logs but `machine1_dev` won't be.
```
-program:dev
```
