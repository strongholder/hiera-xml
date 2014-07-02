## hiera_xml : An XML back end for Hiera


### Description

This is a back end plugin for Hiera that allows lookup to be sourced from XML. It allows you to use xpath selectors as key.

### Configuration

The following is an example hiera.yaml configuration for use with hiera-xml

    :backends:
      - xml

    :xml:
      :data-source:
       - /path/to/xml/file1.xml
       - /path/to/xml/file2.xml
      :paths:
       - "//deployment[@name='%{::hostname}']"
       - "//deployment[@name='%{::deployment}']/vm[server_name='%{::hostname}']"

### Author
* Daniel Popov

