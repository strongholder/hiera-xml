## hiera_xml : An XML back end for Hiera


### Description

This is a back end plugin for Hiera that allows lookup to be sourced from XML.  It allows you to use xpath selectors as key.

### Configuration

The following is an example hiera.yaml configuration for use with hiera-xml

    :backends:
      - xml

    :xml:
      :file: /path/to/xml/file
      :paths:
       - "//deployment[@name='%{::hostname}']"
       - "//deployment[@name='%{::deployment}dev']/vm[server_name='%{::hostname}']"

### Author
* Daniel Popov

