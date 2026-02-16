#!/bin/sh

browser-kiosk $1 "https://www.tailwindcss.com"
