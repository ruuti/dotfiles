#!/usr/bin/env bash
# Replaces sql in clipboard with pg_formatted sql
# 
# Usage:
# pbsql

pbpaste | pg_format | pbcopy
