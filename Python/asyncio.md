## Asyncio

### Run tasks right after creation
```python
import asyncio

async def coro(sec):
    print("start " + str(sec))
    await asyncio.sleep(sec)
    print("stop " + str(sec))

async def main():
    loop = asyncio.get_event_loop()

    task1 = loop.create_task(coro(10))
    task2 = loop.create_task(coro(5))

    # it allows to return control to event loop
    # so other tasks can be run (the one that has just been created)
    await asyncio.sleep(0)

    print("now we are going to wait for the tasks to finish")
    await asyncio.gather(task1, task2)
    print("now we're done")

loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.wait([main()]))
```
See [docs]((https://docs.python.org/3/library/asyncio-task.html#sleeping)) or [stackoverflow](https://stackoverflow.com/questions/56245509/start-async-task-now-await-later) for more.
