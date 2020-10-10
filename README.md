# Object Detectr
A tensorflow object detection model served to the internet on a Rails server.

##### Table of Contents  
  [Demo](#demo)
  [Installation](#install)
  [Troubleshooting](#troubleshooting)
  
<a name="demo"/>
## Demo:
The tensorflow model integrated into this app is quite good at detecting people
![Demo of object detection (humans and cars)](https://media.giphy.com/media/OHpkVYXfKsLQunwScU/giphy.gif)

Its also an excellent cat detector
![Demo of object detection (cat)](https://media.giphy.com/media/2PS7JUvUGHtnXO7UJY/giphy.gif)

Here are a few more detections using this application.
![people detection](https://user-images.githubusercontent.com/35935196/95641582-47602e80-0a71-11eb-933e-8571122a33f4.png)
![food detection](https://user-images.githubusercontent.com/35935196/95641586-49c28880-0a71-11eb-9098-01f519517f04.png)
![dog, tv and human detection](https://user-images.githubusercontent.com/35935196/95641585-4929f200-0a71-11eb-8e92-edcb6ab543ba.png)
![cat and couch detection](https://user-images.githubusercontent.com/35935196/95641584-48915b80-0a71-11eb-90f6-da963a0ed40b.png)

<a name="install"/>
## Installation
### FOR THE AI SIDE (setup protoc, python and install dependencies + script)
The python environment is setup assuming that you are using pyenv and have already installed and set the python version in the project directory

ensure that python version is 3.7.9
``` bash
python --version
```

jump to the models research directory and run the build and install scripts
``` bash
cd potassium/models/research
python setup.py build
python setup.py install
```
grab dependencies
``` bash
pip install TensorFlow==1.15 lxml pillow matplotlib jupyter contextlib2 cython tf_slim
# alternatively you can make sure that pip installs the libraries compatible with your specific python version (3.7.9 is recommended in our case)
python -m pip install TensorFlow==1.15 lxml pillow matplotlib jupyter contextlib2 cython tf_slim
```

### FOR THE RAILS SIDE
```bash
bundle install
rails db:create
rails db:migrate
rails s
```

<a name="troubleshooting"/>
## troubleshooting

1. if Python cannot be found when Ruby makes the system call in potash/app/controllers/images_controller.rb
you can try explicitly pointing to the python version in your $PATH like so:
```ruby
    system("cd #{path_to_python} ; /home/yourUserName/.pyenv/shims/python run.py #{file_name}")
```

2. If the rails app / python script cannot write to disk, allow write by all users (dont do this on a production server)
```bash
chmod -R 777 object-detectr/
```


