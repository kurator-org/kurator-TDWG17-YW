
# define base directories
export PROJECT_ROOT=.
export PACKAGES_DIR=${PROJECT_ROOT}/packages
export BRANCHING_DIR=${PACKAGES_DIR}/kurator_branching
export WORKFLOWS_DIR=${BRANCHING_DIR}/workflows
export DATA_DIR=${BRANCHING_DIR}/data

export XSB="/usr/local/bin/xsb/xsb-3.7/bin/xsb"

# define lcoation of YesWorkflow jar file
#export YW_JAR="${PROJECT_ROOT}/yw_jar/yesworkflow-0.2.2.0-alpha-jar-with-dependencies.jar"
export YW_JAR="${PROJECT_ROOT}/yw_jar/yesworkflow-0.2.2.0-SNAPSHOT-jar-with-dependencies.jar"

# define command for running YesWorkflow
export YW_CMD="java -jar $YW_JAR"

# location of shared Prolog rules, scripts, and queries
export RULES_DIR=${PROJECT_ROOT}/rules
export QUERIES_DIR=${PROJECT_ROOT}/queries

# destination of facts, views and query results
export FACTS_DIR=${WORKFLOWS_DIR}/facts
# export RECON_DIR=${WORKFLOWS_DIR}/recon
export VIEWS_DIR=${WORKFLOWS_DIR}/views
export RESULTS_DIR=${WORKFLOWS_DIR}/results
export LOCALRULES_DIR=${WORKFLOWS_DIR}/myLocalRules
