# RVArchitect

### Contents
**[Overview](#overview)**<br>
**[Installation Instructions](#installation-instructions)**<br>

## Overview 

RVArchitect is a tool that supports runtime verifictation for dynamically evolving architectures.

At this stage of development, the tool has the following key features mainly for specification of ADPs:
* Specification of abstract data types
* Graphical modeling of component types
* Specification of architectural constraints 
* Generation of JavaMOP code from specification

The tool is developed using the Eclipse Modeling Framework (EMF), particularly, with [Obeo](https://www.obeo.fr/en/)'s free and ready-to-use Eclipse package Obeo Designer Community. It includes the technologies required for the development, such as Sirius, Xtext, and Xtend.

## Installation Instructions

A working copy of Obeo Designer Community edition should enable the importing of the FACTum tool metamodel project and runtime sample to start and try the tool. Currently, FACTum Studio works with Obeo Designer Community Version 10.1. Other versions may not run as expected. You may download files required from the following links:

* [Download Eclipse, Obeo Designer](https://www.obeodesigner.com/en/download) *(Needs installing Obeo Designer Community Edition Extensions including Xtext)*

  * First, extract the downloaded Obeo Designer Community zip file into a directory where you would intend to run it.
  * Next, go to the extracted directory and run the file 'obeodesigner' which is the program launcher. 
  * Then, when the program is open and running, install required plugins - Help menu -> Install New Software, these are plugins such as the 'Sirius Integration with Xtext' and 'Xtext Complete SDK' from the Obeo Designer Community Edition Extensions.

* [Download Metamodel Project and Runtime Application](https://goo.gl/fgZN2Y) *(Contains files 'metamodelFACTumS.zip' and 'runtimeFACTumS.zip' )*
  * First, import the project file *'metamodelFACTumS.zip'* into your Obeo Designer Community workspace, 
  * Then, generate Xtext Artifacts from the file Pattern.xtext. 
  * Next, configure an Eclipse runtime application *(e.g., runtimeFACTumS)* to launch the tool's application demo and then
  * Import the file *'runtimeFACTumS.zip'* into your created Eclipse application (runtimeFACTumS) to try and test the FACTum demo.
