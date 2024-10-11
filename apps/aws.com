#!/bin/sh

browser-kiosk $1 "https://eu-north-1.console.aws.amazon.com/console/home?region=eu-north-1#"
