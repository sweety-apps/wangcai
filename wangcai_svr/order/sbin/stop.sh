#!/bin/bash

ps -ef | grep uWSGI | grep order | awk '{print $2}' | xargs kill -9

