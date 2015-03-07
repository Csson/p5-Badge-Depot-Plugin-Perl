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

# VERSION
# ABSTRACT: Perl version plugin for Badge::Depot

has version => (
    is => 'ro',
    isa => Str,
    builder => 1,
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
    default => 'https://img.shields.io/badge/perl-%s-brightgreen.svg',
);

sub BUILD {
    my $self = shift;
    $self->image_url(sprintf $self->custom_image_url, $self->version);
    $self->image_alt(sprintf 'Requires Perl %s', $self->version);
}

sub _build_version {
    my $self = shift;

    return if !path('META.json')->exists;

    my $json = path('META.json')->slurp_utf8;
    my $data = decode_json($json);

    return 'unknown' if !exists $data->{'prereqs'}{'runtime'}{'requires'}{'perl'};

    my $version = $data->{'prereqs'}{'runtime'}{'requires'}{'perl'};

    my $nodot_version = $self->version_from($version, qr{^5\.(\d{3})(\d{3})$});
    my $dotted_version = $self->version_from($version, qr{^5\.(\d+)(?:\.(\d+))?$});

    return $nodot_version || $dotted_version || 'unknown';
}

sub version_from {
    my $self = shift;

    my $version = shift;
    my $regex = shift;

    $version =~ s{^v}{};

    return if $version !~ m{$regex};

    my $major = $1;
    my $minor = $2;

    $major =~ s{^0+}{};
    $minor =~ s{^0+}{}x if defined $minor;

    my $display_version = join '.' => 5, (length $major ? $major : ()), (defined $minor && length $minor ? $minor : ());
    return $display_version . $self->trailing;
}

1;

__END__

=pod

=head1 SYNOPSIS

    use Badge::Depot::Plugin::Perl;

    my $badge = Badge::Depot::Plugin::Perl->new(version => '5.8.5+');

    print $badge->to_html;
    # prints '<img src="https://img.shields.io/badge/perl-5.8.5+-brightgreen.svg" />'

=head1 DESCRIPTION

Creates a Perl version badge, like this:

=for HTML <img src="https://img.shields.io/badge/perl-5.8.5+-brightgreen.svg" />

=for markdown ![Requires Perl 5.8+](https://img.shields.io/badge/perl-5.8.5+-brightgreen.svg)

This class consumes the L<Badge::Depot> role.

=head1 ATTRIBUTES

All attributes are optional.

=head2 version

The minimum supported Perl version. If it isn't given, it looks for a C<prereqs/runtime/requires/perl> entry in C<META.json> and uses that.

If it is neither given or exists in C<META.json>, the string C<unknown> is displayed.

=head2 trailing

A string to add after the version, if the version is fetched from C<META.json>. Defaults to C<+>.

Not used if C<version> is set.

=head2 custom_image_url

By default, this module shows an image from L<shields.io|https://shields.io>. Use this attribute to override that with a custom url. Use a C<%s> placeholder where the version should be inserted.

=head1 SEE ALSO

=for :list
* L<Badge::Depot>

=cut
