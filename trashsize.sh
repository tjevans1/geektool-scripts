#!/bin/bash

#returns size of trash
du -sh ~/.Trash/ | awk '{print "Size:", $1}'