# Time Management Webapp

## See Develop Branch:
Presently, this web app has not released version 1.0, so all work is on the develop branch, rather than the main branch.

https://github.com/ajmetz/management/tree/develop/

## Aims:
The app is aiming to do three things:
1) Process my Time Tracking diary text files, to convert them to simpler Time Logging text files. (Status - POSTPONED until later).
2) Allow Time Logging text to be saved to an SQLite database as a series of entries. (Status - DONE via URL: /entries ).
3) When given a time range, display all entries within that time range in a pie chart, to visualise how time was spent.
It should be possible to drill down from top categories to mid level categories and associated entry details, by clicking on parts of the pie chart.
(Status - WORK-IN-PROGRESS via URL: /days ).

### Example Text formats:

#### Time Tracking Text Example (12th May 2025):

16:41 - wandered off to Dunelm, browsed curtain ties and hooks, and bought a set of two transparent hooks for £4 and a curtain tie for £6.

17:28 - Then went home and stuck it in place, and tested it, and the curtain tie appeared inappropriate. Washed hands, went to toilet, washed hands, then returned to dunelm and secured a refund for the curtain tie.

#### Time Logging Text Example (12th May 2025):

16:41-17:28 - SOLUTION - Curtain fixing. Dunelm refund.

#### Time Logging Text Example used in test files:

See https://github.com/ajmetz/management/blob/develop/project/tests/t2/entry_factory.t