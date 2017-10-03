#!/usr/bin/env bash

# set variables
source settings.sh

# create output directories
mkdir -p $FACTS_DIR
mkdir -p $VIEWS_DIR
mkdir -p $RESULTS_DIR

cp yw_tdwg17_no\@partof.properties yw.properties
# export YW model and extract facts, and draw complete workflow graph with URI template
$YW_CMD graph
dot -Tpdf $RESULTS_DIR/complete_wf_graph_uri.gv > $RESULTS_DIR/complete_wf_graph_uri_no@partof.pdf
dot -Tsvg $RESULTS_DIR/complete_wf_graph_uri.gv > $RESULTS_DIR/complete_wf_graph_uri_no@partof.svg
