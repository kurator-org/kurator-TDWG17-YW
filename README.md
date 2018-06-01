# kurator-TDWG17-YW

Demonstration of revealing data lineage/provenance from biodiversity data curation activities at different levels of granularity on a YesWorkflow marked-up Kurator workflow for TDWG 2017

## Run from Dockerfile

Docker image for kurator-TDWG17-YW demo.

* See the following for installing docker and prerequisites:

    https://docs.docker.com/install/

* [kurator-tdwg17-yw-docker](https://github.com/kurator-org/kurator-TDWG17-YW/tree/master/kurator-tdwg17-yw-docker) Docker Image

    * The [kurator-tdwg17-yw-docker](https://github.com/kurator-org/kurator-TDWG17-YW/tree/master/kurator-tdwg17-yw-docker) contains all the prerequisites installed in a single docker container for running the kurator-TDWG17-YW demo.

    * The configuration and scripts for this container are located in the [kurator-tdwg17-yw-docker](https://github.com/kurator-org/kurator-TDWG17-YW/tree/master/kurator-tdwg17-yw-docker) directory of this top level project.

* Usage

1. First, clone this project via git:

    https://github.com/kurator-org/kurator-TDWG17-YW

2. Next, with docker installed on your local machine, build the kurator-tdwg17-yw-docker container as root via the provided build.sh script:

    ```
    cd kurator-tdwg17-yw-docker 
    sudo ./build.sh
    ```
   
3. Once build has succeeded, run the kurator-tdwg17-yw-docker container via the run.sh script:

    `sudo ./run.sh`

    The working directory will be `kurator-validation`. 

4. Lastly, run the Kurator workflow as well as yesworkflow and associated xsb scripts to generate prospective and hybrid (retrospective) graphs and queries:

     ```
     source settings.sh
     sh clean.sh
     source settings.sh
     sh make.sh
     ```

     The data files in [results](https://github.com/kurator-org/kurator-TDWG17-YW/tree/master/kurator_FileBranchingTaxonLookup/workflows/results) folder is mounted and thus visualized from `~/Downloads/results/` on your host machine.

## Run without Dockerfile 

### Prerequisites

* Install kurator-validation
    * Checkout kurator-validation

        `git clone https://github.com/kurator-org/kurator-validation.git`

    * Build kurator-validation 


    ```
        mvn package -DskipTests
        mkdir  kurator-validation/yw_jar
    ```

   * You may need to checkout and build (mvn install) various other kurator projects, including kurator-akka, and ffdq-api.

* Install YesWorkflow jar (in `kurator-validation/yw_jar`).

    * Obtain `yesworkflow-0.2.1.2-jar-with-dependencies.jar` from:

       https://github.com/yesworkflow-org/yw-prototypes/releases/download/v0.2.1.2/yesworkflow-0.2.1.2-jar-with-dependencies.jar 

* Install XSB 

    Download XSB from https://sourceforge.net/projects/xsb/files/xsb/3.8%20Three-Buck%20Chuck/XSB38.tar.gz/download and install it. 

* Copy `.sh` files and queries into `kurator-validation/` 

    ```
    cd kurator-TDWG17-YW
    cp *.sh ../kurator-validation
    cp -R rules/ ../kurator-validation
    cp -R queries/ ../kurator-validation
    ```

* Set the path to the xsb binary in settings.sh

    e.g.  `export XSB="~/Downloads/xsb-src/XSB/config/i386-apple-darwin17.4.0/bin/xsb"`
 
* Set up the prerequisites for a kurator workflow run (install jython, jython pip install unicodecsv, chardet)

### To run

* Run the Kurator workflow as well as yesworkflow and associated xsb scripts to generate prospective and hybrid (retrospective) graphs and queries: 

```
    source settings.sh
    sh clean.sh
    source settings.sh
    sh make.sh
```

* In particular, to run kurator-validation on the marked-up workflow to generate a logfile for analysis: 

```
    java -jar target/kurator-validation-1.0.2-jar-with-dependencies.jar -f packages/kurator_FileBranchingTaxonLookup/workflows/file_branching_taxon_lookup.yaml -p inputfile=packages/kurator_FileBranchingTaxonLookup/data/kurator_sample_data_v2.txt -l ALL > ./packages/kurator_FileBranchingTaxonLookup/workflows/results/runlog.log 2>&1
```

