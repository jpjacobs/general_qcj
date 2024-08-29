# qcj: Quantum Computing in J

## Status
This addon is the result of my own explorations in Quantum Computing, using J.
Although it is getting quite extensive, it remains a work-in-progress; things may change as I explore more.

One thing to note is: states are implemented as J vectors, i.e. being 1 dimensional. No distinction is made between column or row vectors (as these would have to be 1xN or Mx1 matrices). This choice seems more logical for J, and the user should be aware of this.

Main functionality implemented at the moment are:

- A help function, call `fh ' fh '` for more info;
- `tp` and `mp`: tensor and matrix products;
- `op` and `ip` : outer & inner product of states;
- Many single and multi-qubit gates;
- `N a b... q gate` : apply gate in N qubit system to qubits a, b ...; 
- `rg` : quickly generate a (multi-)qubit register;
- `selm` : selective measurement in the Z-basis, returning probabilities for each bit string and the resulting states;
- `pickst`: based on the results of selective measurement, pick one of the resulting states;
- `rst` creates random y qubit states;
- Bloch sphere coordinates, angles and visualisation of single qubits (`bloch`,`blochv` and `blocha`);
- Histograms of measurement results e.g. show 1000 shot measurement of |+> : `hist 1000 selm shots Sp`.

Partially implemented:
- Projective measurement `pmeas` (but only partly, it does not return states resulting after the measurement).

## Requirements
QCJ runs on j903 or later on all platforms and in all interfaces (JQt, JHS, jconsole, JAndroid, and the [J playground](https://jsoftware.github.io/j-playground/bin/html2/#base64=aW5zdGFsbCdnaXRodWI6anBqYWNvYnMvZ2VuZXJhbF9xY2onCmxvYWQnZ2VuZXJhbC9xY2onCmxvYWRkICdhZGRvbnMvZ2VuZXJhbC9xY2ovZXhhbXBsZXMuaWpzJw==)).
The only library depended on is `graphics/plot` for showing a qubit in the Bloch sphere, and plotting histograms.

Installation instructions:

    install'github:jpjacobs/general_qcj'
    load'general/qcj'

The load defines all names in the 'qcj' locale, and inserts the locale in the base locale's path, so they can be used directly.
You can create a bookmark to the J Playground with qcj.ijs in the editor, ready for running by, after installing it, doing:

    open'~addons/general/qcj.ijs'

After allowing the loading, press "run" (or use ctrl-R) and copy the link of the last run by right-clicking on "Last Run Permalink" in the links menu, and saving the URL as a bookmark.

## Examples
The example file shows plenty of examples going from simple one and two-gate circuits to quantum teleportation and super-dense coding.

You can load the example file in the editor using:

    open '~addons/general/qcj/examples.ijs'
