Reports
=======

Search report
~~~~~~~~~~~~~

You can generate a ``Table`` object containing search results by navigating
to the ``Search report`` command in the menu: ``Finder > Tasks``. Once
selected, a Table object will appear in the Praat Objects window.

The table includes the following columns:

	**tmin:** The starting time of the target interval. For points, 
			  ``tmin`` is equal to ``tmax``.

	**tmax:** the ending time of the target interval. For points, ``tmax``
			  is equal to ``tmin``

	**tier:** The tier where the target interval or point is located.

	**text:** The content (label) of the target interval or point.

	**path:** The file path of the ``TextGrid`` containing the target.

	**notes:** Any notes enter by the user (only if the ``notes`` option 
			   was was activated in the ``View and Edit files`` command).

Frequency report
~~~~~~~~~~~~~~~~

The Frequency report generates a ``Table`` listing each unique matched
label and its total number of occurrences. To create this report,
go to the ``Frequency report`` command in the ``Finder > Tasks`` menu.

The Frequency report offers a ``Table`` with the matched text and the 
number of occurrences. To generate a report, go to the `Frequency report`
command in the ``Finder > Tasks`` menu.

The table includes the following columns:

	**text:** The content (label) of the target interval or point.
	
	**frequency:** The occurrence count for a given category.
