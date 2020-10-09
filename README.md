# potassium

## FOR THE AI SIDE (setup protoc, python and install dependencies + script)
The python environment is setup assuming that you are using pyenv and have already installed and set the python version in the project directory

ensure that python version is 3.7.9
``` bash
python --version
```


``` bash
cd potassium/models/research
python setup.py build
python setup.py install
```

``` bash
pip install TensorFlow==1.15 lxml pillow matplotlib jupyter contextlib2 cython tf_slim
```

```bash
cd potassium/models/research/object_detection
python run.py
```

make sure that the images you want analyzed are in test_images and the outputs folder exists at potassium/models/research/object_detection, and the run.py script image indexes are set (right now its hardcoded). If/when the run.py script is executed the output will be written to the /outputs directory
