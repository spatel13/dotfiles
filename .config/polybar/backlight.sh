#!/bin/bash
exec 2>/dev/null

echo  "$(light | cut -d. -f1)%"
