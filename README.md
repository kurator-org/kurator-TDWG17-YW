# kurator-TDWG17-YW

Demonstration of revealing data lineage/provenance from biodiversity data curation activities at different levels of granularity on a YesWorkflow marked-up Kurator workflow for TDWG 2017

## Prerequisites

Checkout kurator-validation

     git clone https://github.com/kurator-org/kurator-validation.git
     mkdir  kurator-validation/yw_jar

Build kurator-validation 

     mvn package -DskipTests

You may need to checkout and build (mvn install) various other kurator projects, including kurator-akka, and ffdq-api.

Install YesWorkflow jar (in kurator-validation/yw_jar.

Obtain 

yesworkflow-0.2.2.0-SNAPSHOT-jar-with-dependencies.jar.gz

from https://github.com/yesworkflow-org/yw-prototypes/releases/tag/0.2.2.0-alpha

Install xsb

Download xsb from https://xsb.sourceforge.net/ and install it.

Copy .sh files and queries into kurator-validation 

    cd kurator-TDWG17-YW
    cp *.sh ../kurator-validation
    cp -R rules/ ../kurator-validation
    cp -R queries/ ../kurator-validation

into the kurator-validation checkout

Set the path to the xsb binary in settings.sh
e.g.  export XSB="/usr/local/bin/xsb/xsb-3.7/bin/xsb"
 
Set up the prerequisites for a kurator workflow run (install jython, jython pip install unicodecsv, chardet)

## To run

* Run the Kurator workflow as well as yesworkflow and associated xsb scripts to generate prospective and hybrid (retrospective) graphs and queries: 

    ''' source settings.sh
     sh clean.sh
     source settings.sh
     sh make.sh
     '''

* In particular, to run kurator-validation on the marked-up workflow to generate a logfile for analysis: 

     'java -jar target/kurator-validation-1.0.2-jar-with-dependencies.jar -f packages/kurator_FileBranchingTaxonLookup/workflows/file_branching_taxon_lookup.yaml -p inputfile=packages/kurator_FileBranchingTaxonLookup/data/kurator_sample_data_v2.txt -l ALL > ./packages/kurator_FileBranchingTaxonLookup/workflows/results/runlog.log 2>&1'


