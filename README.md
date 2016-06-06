# dcmtkObjc
compile and integrate dcmtk dicom source code into Xcode Objective-C apps.

# background
dcmtk is definitely a reference implementation of DICOM object structures and communication. Written in C++ and C, it compiles with CMake on most platforms, including linux, windows and Mac. The Mac application OsiriX depends heavily on it.

# objective
dcmtkObjc is a work in progress in the art of integrating dcmtk in Mac programming environment. 

The objectives are:
- to facilitate the integration of the source code of dcmtk in objective-C projects
- to use Xcode as workbench
- to create a convenience navigation layer of objective-c wrappers above the C++ clases corresponding to DICOM objects of information (File, MetaInfo, Dataset, Sequence, Item, Element, ...)
- to link these wrappers as nodes of a DICOM tree which admits a syntax similar to XPath  in order to travel from node (a) to node (b).
- to allow a minimalistic exploration of branches of this tree. That is, without creating the whole objective-C tree in memory before.
- to use this convenience navigation layer in a variety of applications for conversion, standardization, data mining and so on.

Have fun learning and creating.