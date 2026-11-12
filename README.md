# Random Tool

A Solr / Blacklight / Ruby on Rails application used to organize and explore the
resources exported from a browser bookmark file.

## Features

- Import URLs from a browser bookmark file
- Search all imported resources through Blacklight
- Generate random resource output (and ChatGPT image output) from the collection

## Requirements

- Ruby 2.7.2
- Rails 5.2.x
- Solr (via `solr_wrapper`)
- SQLite3

## Setup

Install dependencies:

```sh
bundle install
```

## Running the Application

### Start Solr

```sh
solr_wrapper
bundle exec rake tool:reindex
```

### Start the Rails server

```sh
rails server
```

The application is available at http://localhost:3000.

## Importing Resources

Seed the database and import URLs from the bookmark file:

```sh
rails db:seed
rake bookmarks:import
```

## Exporting Resources

Resources can be exported through the Blacklight interface.

## Utilities

Strip URLs from a bookmark HTML file into a plain URL list:

```sh
sed -ne 's|.*\<A HREF="\(http[^"]*\)".*|\1|p' bookmarks_2_6_14.html > bookmark_url.lst
```

## Key Routes

- `/catalog` — Blacklight search catalog (application root)
- `/resources` — Resource management
- `/random_output` — Random resource output
- `/chatgpt_image_output` — ChatGPT image output

