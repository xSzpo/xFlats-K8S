Create conda env
```
conda env create -f conda.yaml
```

Update conda env
```
conda env update -f conda.yaml
```

Jupyter kernel
```
conda activate flats_mlmodel
ipython kernel install --user --name=flats_mlmodel
ipython kernelspec list
```


Conda activate
```
conda activate flats_mlmodel
```


DOC
```
cd XSZPO
pdoc -f --html .
```