#!/bin/sh

-e

CMD wget -q --spider http://localhost:5173 || exit 1