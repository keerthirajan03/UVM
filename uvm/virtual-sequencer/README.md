In this example, we have three dummy agents which have their own sequences. They don't do any protocol level transfers, but simply print out some display messages since our idea is to understand how a virtual sequencer works.
A "virtual sequencer" contains different handles to respective sequencers, and a "virtual sequence" starts different sequences. The "virtual sequence" is executed by the virtual sequencer, and each sequence inside the virtual
sequence is started on corresponding sequencer by utilizing the handles made available in "virtual sequencer".
