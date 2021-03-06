#!/bin/bash
py2="2.7"
py3="3.5"

function run_version(){
export PYENV_VERSION=$1
if [[ $KERAFLOW_BACKEND == tensorflow ]]; then
    py.test tests
elif [[ $KERAFLOW_BACKEND == theano ]]; then
    THEANO_FLAGS=optimizer=fast_compile py.test tests
else
    py.test --pep8 -m pep8 keraflow tests
fi
}

function on_fail(){
    echo == $@  check failed ==
    exit 1
}


if [[ $TRAVIS_PYTHON_VERSION == $py2 ]]; then
    run_version k2
elif [[ $TRAVIS_PYTHON_VERSION == $py3 ]]; then
    run_version k3
else
    run_version k2  || on_fail PEP8
    KERAFLOW_BACKEND=tensorflow run_version k2 || on_fail python2 tensorflow
    KERAFLOW_BACKEND=theano run_version k3 || on_fail python3 theano

    # I think the above is enough for developer checking.
    # KERAFLOW_BACKEND=tensorflow run_version k3 || on_fail python3 tensorflow
    # KERAFLOW_BACKEND=theano run_version k2 || on_fail python2 theano
fi
