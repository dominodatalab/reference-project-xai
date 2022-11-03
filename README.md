*Disclaimer - Domino Reference Projects are starter kits built by Domino researchers. They are not officially supported by Domino. Once loaded, they are yours to use or modify as you see fit. We hope they will be a beneficial tool on your journey!

## Welcome to the Domino Reference Project for...

# Explainable AI

![img](https://github.com/dominodatalab/domino-reference-project-xai/blob/master/scratch/blackbox.png?raw=true)

Model interpretability is a seminal topic in the field of data science. 
The field is moving quickly. Practitioners can leverage a range of tools to provide 
explainability to their models from traditional approaches to the latests in deep neural 
network explainers.

## Project Contents

This project contains starter code for a few of these approaches and some educational material on xAI.

* [SHAP_and_LIME.ipynb](./view/SHAP_and_LIME.ipynb)  -  a how-to notebook
* [rtemis.R](./view/rtemis.R)  -  a how-to R file
* [traditional_methods.ipynb](./view/traditional_methods.ipynb)  -  a how-to notebook
* [Navigating Interpretable and Predictive Models.pdf](./view/Navigating+Interpretable+and+Predictive+Models.pdf)  -  slides from the Domino tech talk on xAI which includes many links to further research

## Suggested Actions

* Explore the SHAP_and_LIME.ipynb notebook

## Reference Material

* Learn more about xAI by browsing the instructional pdf
* updaetd project files can be found at [https://github.com/dominodatalab/domino-reference-project-xai](https://github.com/dominodatalab/domino-reference-project-xai)

## Prerequisites

This project uses standard python libraries and any base Domino image should work well. The last test was done on *standard-environment:ubuntu18-py3.8-r4.1-domino5.1*.

Dockerfile instructions used are below. You may not need all these to recreate the environment:

```
RUN mkdir -p /opt/domino

### Modify the Hadoop and Spark versions below as needed.
ENV HADOOP_VERSION=3.2.1
ENV HADOOP_HOME=/opt/domino/hadoop
ENV HADOOP_CONF_DIR=/opt/domino/hadoop/etc/hadoop
ENV SPARK_VERSION=3.0.0
ENV SPARK_HOME=/opt/domino/spark
ENV PATH="$PATH:$SPARK_HOME/bin:$HADOOP_HOME/bin"

### Install the desired Hadoop-free Spark distribution
RUN rm -rf ${SPARK_HOME} && \
    wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz && \
    tar -xf spark-${SPARK_VERSION}-bin-without-hadoop.tgz && \
    rm spark-${SPARK_VERSION}-bin-without-hadoop.tgz && \
    mv spark-${SPARK_VERSION}-bin-without-hadoop ${SPARK_HOME} && \
    chmod -R 777 ${SPARK_HOME}/conf

### Install the desired Hadoop libraries
RUN rm -rf ${HADOOP_HOME} && \
    wget -q http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xf hadoop-${HADOOP_VERSION}.tar.gz && \
    rm hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} ${HADOOP_HOME}

### Setup the Hadoop libraries classpath and Spark related envars for proper init in Domino
RUN echo "export SPARK_HOME=${SPARK_HOME}" >> /home/ubuntu/.domino-defaults
RUN echo "export HADOOP_HOME=${HADOOP_HOME}" >> /home/ubuntu/.domino-defaults
RUN echo "export HADOOP_CONF_DIR=${HADOOP_CONF_DIR}" >> /home/ubuntu/.domino-defaults
RUN echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${HADOOP_HOME}/lib/native" >> /home/ubuntu/.domino-defaults
RUN echo "export PATH=\$PATH:${SPARK_HOME}/bin:${HADOOP_HOME}/bin" >> /home/ubuntu/.domino-defaults
RUN echo "export SPARK_DIST_CLASSPATH=\"\$(hadoop classpath):${HADOOP_HOME}/share/hadoop/tools/lib/*\"" >> ${SPARK_HOME}/conf/spark-env.sh

### Complete the PySpark setup from the Spark distribution files
WORKDIR $SPARK_HOME/python
RUN python setup.py install

### Optionally copy spark-submit to spark-submit.sh to be able to run from Domino jobs
RUN spark_submit_path=$(which spark-submit) && \
    cp ${spark_submit_path} ${spark_submit_path}.sh
    
ENV SPARK_RAPIDS_DIR=/opt/sparkRapidsPlugin
RUN wget -q -P $SPARK_RAPIDS_DIR https://repo1.maven.org/maven2/com/nvidia/rapids-4-spark_2.12/0.1.0/rapids-4-spark_2.12-0.1.0.jar
RUN wget -q -P $SPARK_RAPIDS_DIR https://repo1.maven.org/maven2/ai/rapids/cudf/0.14/cudf-0.14-cuda10-1.jar
ENV SPARK_CUDF_JAR=${SPARK_RAPIDS_DIR}/cudf-0.14-cuda10-1.jar
ENV SPARK_RAPIDS_PLUGIN_JAR=${SPARK_RAPIDS_DIR}/rapids-4-spark_2.12-0.1.0.jar
```

Plugable workshpace tools:

```
jupyter:
  title: "Jupyter (Python, R, Julia)"
  iconUrl: "/assets/images/workspace-logos/Jupyter.svg"
  start: [ "/var/opt/workspaces/jupyter/start" ]
  httpProxy:
    port: 8888
    rewrite: false
    internalPath: "/{{ownerUsername}}/{{projectName}}/{{sessionPathComponent}}/{{runId}}/{{#if pathToOpen}}tree/{{pathToOpen}}{{/if}}"
    requireSubdomain: false
  supportedFileExtensions: [ ".ipynb" ]
jupyterlab:
  title: "JupyterLab"
  iconUrl: "/assets/images/workspace-logos/jupyterlab.svg"
  start: [  /var/opt/workspaces/Jupyterlab/start.sh ]
  httpProxy:
    internalPath: "/{{ownerUsername}}/{{projectName}}/{{sessionPathComponent}}/{{runId}}/{{#if pathToOpen}}tree/{{pathToOpen}}{{/if}}"
    port: 8888
    rewrite: false
    requireSubdomain: false
vscode:
 title: "vscode"
 iconUrl: "/assets/images/workspace-logos/vscode.svg"
 start: [ "/var/opt/workspaces/vscode/start" ]
 httpProxy:
    port: 8888
    requireSubdomain: false
rstudio:
  title: "RStudio"
  iconUrl: "/assets/images/workspace-logos/Rstudio.svg"
  start: [ "/var/opt/workspaces/rstudio/start" ]
  httpProxy:
    port: 8888
    requireSubdomain: false
```
