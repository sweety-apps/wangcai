#!/bin/bash

ps -ef | grep uWSGI | grep app | awk '{print $2}' | xargs kill -9

