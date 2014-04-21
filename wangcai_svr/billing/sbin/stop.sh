#!/bin/bash

ps -ef | grep uWSGI | grep billing | awk '{print $2}' | xargs kill -9

