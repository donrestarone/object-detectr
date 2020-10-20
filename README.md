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

![horse and human detection](https://user-images.githubusercontent.com/35935196/95678138-b1bfbe80-0b98-11eb-90dd-5fcc49ed5794.png)

![cat and couch detection](https://user-images.githubusercontent.com/35935196/95641584-48915b80-0a71-11eb-90f6-da963a0ed40b.png)

<a name="install"/>

## Installation
### FOR THE AI SIDE (setup protoc, python and install dependencies + script)

1. The python environment is setup assuming that you are using pyenv and have already installed and set the python version in the project directory
2. [If you are setting up python from scratch you can use this gist](https://gist.github.com/donrestarone/ccca19bb6ded91ca3fb6d71f46339899)
3. ensure that python version is 3.7.9

``` bash
python --version
```
Clone the repository
jump to the models research directory and run the build and install scripts
``` bash
cd object_detectr/models/research
python setup.py build
python setup.py install
```
grab dependencies
``` bash
pip install TensorFlow==1.15 lxml pillow matplotlib jupyter contextlib2 cython tf_slim
# alternatively you can make sure that pip installs the libraries compatible with your specific python version (3.7.9 is recommended in our case)
python -m pip install TensorFlow==1.15 lxml pillow matplotlib jupyter contextlib2 cython tf_slim
# sometimes on EC2 there is not enough cache for installing these heavy libraries. pass the no cache option if installation is failing silently
python -m pip install --no-cache-dir TensorFlow==1.15 lxml pillow matplotlib jupyter contextlib2 cython tf_slim
```

### FOR THE RAILS SIDE
1. If you are setting up rails from scratch (like on a server) you can use this gist: https://gist.github.com/donrestarone/0ebe1e87b39f0f92f850c1da861e85de
2. for a production nginx configuration (super hacky) you can use this gist: https://gist.github.com/donrestarone/e8b1157dc4a3adffe3450edd55a6f315
```bash
cd object_detectr/potash
bundle install
rails db:create
rails db:migrate
rails s
```
### Running in production
create systemctl service for starting puma on boot. make sure ExecStart/ExecStop are pointing to the rbenv binary and the User has ownership over the var/www directory
``` bash
[Unit]
Description=Puma Rails Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/var/www/object-detectr/potash
ExecStart=/home/ubuntu/.rbenv/bin/rbenv exec bundle exec puma -C /var/www/object-detectr/potash/config/puma.rb
ExecStop=/home/ubuntu/.rbenv/bin/rbenv exec bundle exec pumactl -S /var/www/object-detectr/potash/tmp/pids/puma.state stop
TimeoutSec=15
Restart=always


[Install]
WantedBy=multi-user.target
```
After double checking the RAILS_ENV is pointing to production & RAILS_SERVE_STATIC_FILES=true, reload systemd and start puma
```bash
sudo systemctl daemon-reload
sudo systemctl enable puma.service
sudo systemctl start puma.service
sudo systemctl status puma.service
```
Create the nginx virtualhost configuration for reverse proxying requests to the puma/rails server
``` bash
sudo nano /etc/nginx/sites-available/YOUR_SITE.conf
```
fill in the file with the details, proxying requests coming to port 80
```bash
server {
    listen 80;
    server_name  potassium.shashike.me;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
symlink the virtualhost, test and restart nginx
``` bash
sudo ln -s /etc/nginx/sites-available/potassium.shashike.me.conf /etc/nginx/sites-enabled/potassium.shashike.me.conf
sudo service nginx configtest
sudo service nginx reload
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


