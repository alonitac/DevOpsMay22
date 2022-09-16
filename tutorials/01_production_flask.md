# Deploy Flask backend app with Apache

The following steps should be performed as the `root` user. It is highly recommended connecting to the `root` shell by:

```shell
sudo su -l root
```

## Create a Python virtual env

Let's create first a Python virtual environment 

1. **As a `root` user**, go to `/var/www`
2. Create a venv called `myapp` by: 

```shell
python3 -m venv myapp
```

3. Activate the venv by:
```shell
. myapp/bin/activate
```

## Install OS and Python dependencies

4. Install the `mod_wsgi` apache module **for Python 3**. Problem: Amazon Linux 2 is shipped with Python 2 by default, hence, `yum install mod_wsgi` will install the module for Python 2. Use `yum search wsgi` to search the exact package name for Python 3.
5. Install Apache and Python additional dependencies:
```shell
yum install httpd-devel gcc python3-devel
```
6. Within the virtual env, install python dependencies:
```shell
pip install flask 
pip install mod_wsgi
```

## Copy the application code

7. Copy the application source code into the app directory in the server (`/var/www/myapp`):
   1. [myapp.wsgi](../05_simple_webserver/myapp.wsgi) - this file contains the code `mod_wsgi` is executing on startup to get the application object. The object called `application` in that file is then used as the application Python object.
   2. [app.py](../05_simple_webserver/app.py) - the python flask backend file.

## Configure the Apace server

8. Configure a VirtualHost in Apache configurations file (`/etc/httpd/conf/httpd.conf`) with the following directives:
```shell

<VirtualHost *:8081>
        DocumentRoot /var/www/myapp
        WSGIDaemonProcess myapp python-path=/var/www/myapp
        WSGIScriptAlias /myapp /var/www/myapp/myapp.wsgi
        
          # configurations ....
          
</VirtualHost>
```
8. Restart the `httpd` service.
9. Visit your app in `http://<ip>:8081/myapp`.
