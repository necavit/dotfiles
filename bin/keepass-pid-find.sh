#!/bin/bash

ps aux | head -n 1; ps aux | grep -v grep | grep -i pass
