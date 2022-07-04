import subprocess
from behave import *
import app
import threading


student_solution_output = ''


@given('server is up and running {text}')
def step_impl(context, text):
    app.client_secrets = {}
    app.close()
    if text == 'with valid certificate':
        app.eve_cert = app.bob_cert
    else:
        app.bob_cert = app.eve_cert

    threading.Thread(target=app.run_server, args=(app.main(),)).start()
    threading.Timer(5, app.close).start()


@when('student solution is executed')
def step_impl(context):
    global student_solution_output
    with open('../tlsHandshake.sh') as f:
        script = f.read()

    script = script.replace('devops-jan22-1273001359.eu-north-1.elb.amazonaws.com:8080', '127.0.0.1:8080')

    with open('../tmpStudentSolution.sh', 'w') as f:
        f.write(script)

    process = subprocess.Popen('/bin/bash ../tmpStudentSolution.sh', shell=True, stdout=subprocess.PIPE)
    process.wait()
    student_solution_output = process.stdout.readlines()
    print(student_solution_output)


@then('client_hello called once')
def step_impl(context):
    length = len(app.client_secrets)
    if length != 1:
        print(f'server got {length} client_hello requests instead of 1')

    assert len(app.client_secrets) == 1


@then('key_exchange called once with the same session id')
def step_impl(context):
    length = len(app.client_secrets)
    assert length == 1
    assert list(app.client_secrets.values())[0] is not None


@then('student program exits with success message')
def step_impl(context):
    assert 'Client-Server TLS handshake has been completed successfully' in str(student_solution_output)

