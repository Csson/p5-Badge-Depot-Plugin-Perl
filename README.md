# NAME

Badge::Depot::Plugin::Perl - Perl version plugin for Badge::Depot

# VERSION

Version 0.0001, released 2015-03-07.

# SYNOPSIS

    use Badge::Depot::Plugin::Perl;

    my $badge = Badge::Depot::Plugin::Perl->new(version => '5.8.5+');

    print $badge->to_html;
    # prints '<img src="https://img.shields.io/badge/perl-5.8.5+-brightgreen.svg" />'

# DESCRIPTION

Creates a Perl version badge, like this:

This class consumes the [Badge::Depot](https://metacpan.org/pod/Badge::Depot) role.

# ATTRIBUTES

All attributes are optional.

## version

The minimum supported Perl version. If it isn't given, it looks for a `prereqs/runtime/requires/perl` entry in `META.json` and uses that.

If it is neither given or exists in `META.json`, the string `unknown` is displayed.

## trailing

A string to add after the version, if the version is fetched from `META.json`. Defaults to `+`.

Not used if `version` is set.

## custom\_image\_url

By default, this module shows an image from [shields.io](https://shields.io). Use this attribute to override that with a custom url. Use a `%s` placeholder where the version should be inserted.

# SEE ALSO

- [Badge::Depot](https://metacpan.org/pod/Badge::Depot)

# SOURCE

[https://github.com/Csson/p5-Badge-Depot-Plugin-Perl](https://github.com/Csson/p5-Badge-Depot-Plugin-Perl)

# HOMEPAGE

[https://metacpan.org/release/Badge-Depot-Plugin-Perl](https://metacpan.org/release/Badge-Depot-Plugin-Perl)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Erik Carlsson <info@code301.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
