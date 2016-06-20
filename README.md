# Celery Docset

Documentation for the [Celery](http://www.celeryproject.org/) Distributed Task Queue as a [Dash](http://kapeli.com/dash) docset.

## How to generate the docset

Install [doc2dash](https://github.com/hynek/doc2dash):
```bash
$ pip install doc2dash
```

Move to a directory of choice and execute the following commands:
```bash
$ git clone https://github.com/cwill747/celery-docset.git
$ cd celery-docset
$ ./generate.sh
```

Once generated, the Celery docset can be found under the `dist` folder. To install the docset, execute the following command:
```bash
$ ./install.sh
```