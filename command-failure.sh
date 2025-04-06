#!/bin/bash

commandFailure() {
    echo -e "\e[31m$1\e[0m" >&2
    exit 1
}
