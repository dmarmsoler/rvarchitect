# FACTum Studio
[//]: # (Architectural Design Constraints Specification and Verification)

FACTum Studio is a tool that supports Architectural Design Patterns (ADPs) specification and verification with the support of interactive verification in Isabelle/HOL.

At this stage of development, the tool has the following key features mainly for specification of ADPs:
* Specification of abstract data types
* Graphical modeling of component types
* Specification of architectural constraints 
* Specification of architectural guarantees and
* Generation of Isabelle/HOL theory from ADP specification.

The tool is developed using the Eclipse Modeling Framework (EMF), which includes Sirius, Xtext, and Xtend.  

A working copy of Obeo Designer Community edition should enable the importing of the FACTum tool metamodel project and runtime sample to start and try the tool. You may download and try the FACTum Studio from the following links. 

[Download Eclipse, Obeo Designer](https://www.obeodesigner.com/en/download) *(Needs installing Obeo Designer Community Extensions)*

[Download FACTum Metamodel Project and Runtime Application](https://goo.gl/fgZN2Y) *(Contains files 'metamodelFACTumS.zip' and 'runtimeFACTumS.zip' )*
* First, import the project file metamodelFACTumS.zip into your Obeo Designer Community workspace, 
* The, generate Xtext Artifacts from the file Pattern.xtext. 
* Next, configure an Eclipse runtime application (e.g., runtimeFACTumS) to launch the tool's application demo and then
* Import the file runtimeFACTumS.zip into your created Eclipse application (runtimeFACTumS) to try and test the FACTum demo.
