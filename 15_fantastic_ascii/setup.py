from setuptools import setup, find_packages

setup_args = dict(
    name='fantastic_ascii',
    version='1.1.0',
    description='Fantastic ASCII',
    license='MIT',
    install_requires=[
        'requests',
        'importlib-metadata; python_version == "3.8"',
    ],
    author='Matt',
    author_email='example@example.com'
)


if __name__ == '__main__':
    setup(**setup_args)
