#!/bin/bash

ps -ef | grep uWSGI | grep task | awk '{print $2}' | xargs kill -9

