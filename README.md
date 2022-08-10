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

This project uses standard python libraries and any base Domino image should work well. The last test was done on *standard-environment:ubuntu18-py3.8-r4.1-domino5.1*. The additional Python libraries needed are *shap*, *lime*, and *pycebox*. You can simply install them in the cell provided when running the notebook interactively. Alternatively, you can add them to a custom compute environment by appending the following lines to the *standard-environment:ubuntu18-py3.8-r4.1-domino5.1* dockerfile:

```
RUN echo "ubuntu    ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN pip install --upgrade pip
RUN pip install pycebox \
                lime \
                shap
```

There are several additional R libraries needed to run *rtemis*. This library changes frequently, sometimes breaking dependencies, so we do not advise building a compute environment for the current dependencies. See the R scipt included in this project for details.
