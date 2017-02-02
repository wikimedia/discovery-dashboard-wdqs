Wikidata Query Service (WDQS) endpoint usage
=======

This displays data on the use of the Wikidata Query Service (WDQS). Amongst other things, you can filter out automated software (or what looks like automated software) although this option does not operate on data prior to 3 December 2015.

Outages and inaccuracies
------

- **'A'**: We announced WDQS to the public.
- **'B'**: From 2015-11-04 to 2015-11-06 there was what we believe to be a broken bot responsible for 21+ million requests.
- **'C'**: As part of a refactoring to a new metric-generating framework (see [T150915](https://phabricator.wikimedia.org/T150915)), we revised the ruleset for determining when a request came from a bot/tool. For example, requests with URLs and email addresses in the UserAgent were classified as automata after 2016-12-28.
- **'D'**: We started tracking LDF endpoint usage on 2017-01-01. See [T153936](https://phabricator.wikimedia.org/T153936) and [T136358](https://phabricator.wikimedia.org/T136358) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/wdqs/#wdqs_usage">
    http://discovery.wmflabs.org/wdqs/#wdqs_usage
  </a>
</p>
