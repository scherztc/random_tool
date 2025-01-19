# README

This Solr/Blacklight/RoR Application is used to organize the Resources that come from my Bookmark file.

It can

Import URLs from Bookmark
Search all the Resources in the Bookmark

Things you may want to cover:

* SOLR

solr_wrapper
bundle exec rake tool:reindex 

* Rails Sever

rails server

* Import URLs

rails db:seed

* Strips URLs from Bookmark File

sed -ne 's|.*\<A HREF="\(http[^"]*\)".*|\1|p' bookmarks_2_6_14.html > bookmark_url.lst

