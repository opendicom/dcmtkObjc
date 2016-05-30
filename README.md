# dcmtkObjc
compile and integrate dcmtk dicom source code into Xcode Objective-C apps.

# background
dcmtk is definitely a reference implementation of DICOM object structures and communication. Written in C++ and C, it compiles with CMake on most platforms, including linux, windows and Mac. The Mac application OsiriX depends heavily on it.

# objective
dcmtkObjc is a work in progress in the art of integrating dcmtk in Mac environment. 

The objectives are:
- to facilitate the integration of the source code of dcmtk in objective-C projects
- to use Xcode as workbench (instead of CMake)
- to create a convenience layer of objective-c wrappers above the clases which structure DICOM objects of information (File, MetaInfo, Dataset, Sequence, Item, Element, ...)
- to link these clases as nodes of a DICOM tree which admits a syntax similar to XPath  in order to travel from node a to node b.
- to allow the exploration of branches of this tree without requiring to transform the whole DICOM file into a DOM tree before.
- to use this convenience layer in a variety of applications for conversion, standardization, data mining and so on.

dcmtkObjc deals with structures only, that is, we ignore deliberately the communication part of dcmtk, and also the electronic signature part.

# thanks
dcmtkObjc is grateful to:
- the dcmtk team, 
- Lance Physer and the OsiriX team, who realized a great job in compiling dcmtk from Xcode instead of CMake.

Have fun learning and creating.