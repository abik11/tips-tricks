## Jupyter and Pandas

### Start jupyter
```
jupyter notebook
```

### Jupyter shortcuts
* `SHIFT + ENTER` - execute a cell and add new one 
* `CTRL + ENTER` - execute a cell 
* `ENTER` - enter edit mode 
* `ESC` - exit edit mode (and enter command mode) 
* `A` - add a cell **above** the current one
* `B` -  add a cell **below** the current one
* `X` - cut a cell (quick way to delete cells)
* `V` - paste a cell
* `TAB` - autocompletion 
* `SHIFT + TAB` - method's information

### Read a column from CSV file as a Series
```python
import pandas as pd
s = pd.read_csv('data.csv', usecols = ['title'], squeeze = True)
```

### Series
```python
s = pd.Series([1, 2, 3])
s = pd.Series([1, 2, 3], ['x', 'y', 'z']) #second argument is an index - optional
s = pd.Series({'x': 1, 'y': 2, 'z': 3})

list(s) #convert Series to a list
dict(s) #convert Series to a dictionary
min(s)
max(s)
sorted(s)
10 in s.index
"Test" in s.values
```

* Series methods: keys, sort_values(ascending=True/False), sort_index, head(x=5), tail(x=5), describe, value_counts, idxmax, idxmin, apply(function), to_list, to_dict
* Series attributes: index, values, dtype, is_unique, shape
