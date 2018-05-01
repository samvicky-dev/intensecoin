#!/bin/bash
./intensecoind \
	--block-sync-size 20 \
	--add-exclusive-node 140.82.9.90:48772 \
	--add-exclusive-node 62.48.164.60:48772 \
	--add-exclusive-node 5.249.27.162:48772 \
	--add-exclusive-node=54.37.87.203:48772 \
	--add-exclusive-node=159.89.249.113:48772 \
	--add-exclusive-node 64.99.80.121:48772
