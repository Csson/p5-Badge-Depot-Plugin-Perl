use 5.10.0;
use strict;
use warnings;

package Badge::Depot::Plugin::Perl;

use Moose;
use namespace::autoclean;
use MooseX::AttributeShortcuts;
use Types::Standard qw/Str Bool/;
use Types::URI qw/Uri/;
use JSON::MaybeXS 'decode_json';
use Path::Tiny;
with 'Badge::Depot';

# ABSTRACT: Perl version plugin for Badge::Depot
# AUTHORITY
our $VERSION = '0.0104';

has version => (
    is => 'ro',
    isa => Str,
    builder => 1,
    lazy => 1,
    predicate => 1,
);
has trailing => (
    is => 'ro',
    isa => Str,
    default => '+',
);
has custom_image_url => (
    is => 'ro',
    isa => Uri,
    coerce => 1,
    lazy => 1,
    default => 'https://img.shields.io/badge/perl-%s-%s.svg',
);
has color => (
    is => 'ro',
    isa => Str,
    default => 'blue',
);


sub BUILD {
    my $self = shift;

    $self->image_url(sprintf $self->custom_image_url, $self->version, $self->color);
    $self->image_alt(sprintf 'Requires Perl %s', $self->version);
}

sub _build_version {
    my $self = shift;

    return 'unknown' if !path('META.json')->exists;

    my $json = path('META.json')->slurp_utf8;
    my $data = decode_json($json);

    return 'unknown' if !exists $data->{'prereqs'}{'runtime'}{'requires'}{'perl'};

    my $version = $data->{'prereqs'}{'runtime'}{'requires'}{'perl'};

    if($version =~ m{^5\.(\d{3})(\d{3})$}) {
        my $major = $1;
        my $minor = $2;
        $major =~ s{^0+}{};
        $minor =~ s{^0+}{};
        $version = "5.$major" . ($minor ? ".$minor" : '');
        $version .= $self->trailing;
    }
    elsif($version =~ m{^5\.(\d+)(?:\.(\d+))?$}) {
        $version =~ s{\.0+}{.}g;
        $version =~ s{\.+$}{};
        $version .= $self->trailing;
    }
    else {
        $version = 'unknown';
    }
    return $version;

}

1;

__END__

=pod

=head1 SYNOPSIS

If used standalone:

    use Badge::Depot::Plugin::Perl;

    my $badge = Badge::Depot::Plugin::Perl->new(version => '5.8.5+');

    print $badge->to_html;
    # prints '<img src="https://img.shields.io/badge/perl-5.8.5+-blue.svg" />'

If used with L<Pod::Weaver::Section::Badges>, in weaver.ini:

    [Badges]
    ; other settings
    badge = Perl
    -perl_version = 5.8.5

=head1 DESCRIPTION

Creates a Perl version badge, like this:

=for html <img src="https://img.shields.io/badge/perl-5.8.5+-blue.svg" />

This class consumes the L<Badge::Depot> role.

=head1 ATTRIBUTES

All attributes are optional.

=head2 version

The minimum supported Perl version. If it isn't given, it looks for a C<prereqs/runtime/requires/perl> entry in C<META.json> and uses that.

It is set to 'unknown' if it is neither given or exists in C<META.json>.

=head2 trailing

A string to add after the version, if the version is fetched from C<META.json>. Defaults to C<+>.

Not used if C<version> is explicitly set.

=head2 custom_image_url

By default, this module shows an image from L<shields.io|https://shields.io>. Use this attribute to override that with a custom url. Use a C<%s> placeholder where the version should be inserted.

=head2 color

Default: C<blue>

See L<shields.io|https://shields.io> for possible colors.

=head1 SEE ALSO

=for :list
* L<Badge::Depot>
* L<Task::Badge::Depot>

=cut
