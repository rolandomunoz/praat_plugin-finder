Step 2: Search
--------------

Once TextGrid files are indexed (see :doc:`01-create_index`), you can 
search for specific words or patterns within them. This is essential 
for the tasks discussed in :doc:`03-tasks`.

**Searching for specific words**

In :numref:`search-window`, the dialog box is configured to search for 
all labels that match the word "pipa" within the "words" tier.

    #. **Open Search window:** Go to Finder > Search.
    #. **Specify search:**
        * **Tier name:** Select the tier to search (e.g., "words").
        * **Search for:** Enter the word (e.g., "papa").
        * **Mode:** Choose ``is equal to`` for exact matches.
    #. **Run search:** Click OK.
    #. **View results:** Check the Praat Info window for matches.

    #. **View results:** .

    .. _search-window:
    
    .. figure:: img/search-window.png
       :align: center
    
       The ``Search`` window
    
    .. _search-results:
    
    .. figure:: img/search-results.png
       :align: center
    
       Results in the ``Praat Info`` after running the ``Search`` command

**Searching for all items:**

To search for all transcribed items (non-empty items) in a specific
tier, follow the same steps as above, but leave the **Search for** field
empty and choose ``is not equal to`` in the Mode options.
    
    .. _search-window2:
    
    .. figure:: img/search-window2.png
       :align: center
    
       ``Search`` window
    
    .. _search-results2:
    
    .. figure:: img/search-results2.png
       :align: center
    
       Results in the ``Praat Info`` after running the ``Search`` command

**Using Regular Expressions (advanced):**

	#. Enable ``matches (regex)`` mode in the Search window.
	#. Use patterns like ``p[ae]pa`` to match both "papa" and "pepa".
	#. See the Praat `Regular Expressions Tutorial`_ for more details. 
    
    .. _search-window3:
    
    .. figure:: img/search-window3.png
       :align: center
    
       The ``Search`` window
    
    .. _search-results3:
    
    .. figure:: img/search-results3.png
       :align: center
    
       Results in the ``Praat Info`` after running the ``Search`` command
    
    .. _Regular Expressions Tutorial: https://www.fon.hum.uva.nl/praat/manual/Regular_expressions.html

Now you are ready for :doc:`03-tasks`.
