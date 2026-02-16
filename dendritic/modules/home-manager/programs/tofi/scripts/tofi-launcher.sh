#!/usr/bin/env bash

tofi-drun --config "$HOME/.config/tofi/multi-line" --drun-launch=false | xargs -I {} bash -c {}
