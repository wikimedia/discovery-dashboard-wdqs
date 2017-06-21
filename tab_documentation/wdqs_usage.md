Wikidata Query Service (WDQS) endpoint usage
=======

This displays data on the use of the Wikidata Query Service (WDQS). Amongst other things, you can filter out automated software (or what looks like automated software) although this option does not operate on data prior to 3 December 2015.

Outages and inaccuracies
------

* '__A__': We announced WDQS to the public.
* '__B__': From 2015-11-04 to 2015-11-06 there was what we believe to be a broken bot responsible for 21+ million requests.
* '__C__': As part of a refactoring to a new metric-generating framework (see [T150915](https://phabricator.wikimedia.org/T150915)), we revised the ruleset for determining when a request came from a bot/tool. For example, requests with URLs and email addresses in the UserAgent were classified as automata after 2016-12-28.
* '__D__': We started tracking LDF endpoint usage on 2017-01-01. See [T153936](https://phabricator.wikimedia.org/T153936) and [T136358](https://phabricator.wikimedia.org/T136358) for more details.
* '__E__': We noticed that we were undercounting SPARQL usage because we were not including requests made to '/sparql' alias for '/bigdata/namespace/wdq/sparql'. We fixed the counting query on 2017-04-20 but could only recount from 2017-02-18. See [T163501](https://phabricator.wikimedia.org/T163501) for more details.
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/wdqs/#endpoint_usage">https://discovery.wmflabs.org/wdqs/#endpoint_usage</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDTS/" title="WDQS Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDTS/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
