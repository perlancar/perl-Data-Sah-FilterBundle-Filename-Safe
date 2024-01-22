package Data::Sah::Filter::perl::Filename::Safe::alphanum_dash;

use 5.010001;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

sub meta {
    +{
        v => 1,
        summary => 'Replace characters that are not [A-Za-z0-9_-] with underscore (_)',
        description => <<'MARKDOWN',

This is just like the `alphanum`
(<pm:Data::Sah::Filter::perl::Filename::Safe::alphanum>) filter except dash
(`-`) is also allowed.

If you want to avoid the first character being dash, you can use the
`alphanum_dash_no_dash_at_start`
(<pm:Data::Sah::Filter::perl::Filename::Safe::alphanum_dash_no_dash_at_start>)
filter instead.

MARKDOWN
        might_fail => 0,
        args => {
        },
        examples => [
            {value => '', filtered_value => ''},
            {value => 'foo', filtered_value => 'foo'},
            {value => '123  456-789.foo.bar', filtered_value => '123_456-789_foo.bar'},
            {value => '-123  456-789.foo.bar', filtered_value => '-123_456-789_foo.bar'},
        ],
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $gen_args = $fargs{args} // {};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { ", (
            "my \$tmp = $dt; my \$ext; \$tmp =~ s/\\.(\\w+)\\z// and \$ext = \$1; \$tmp =~ s/[^A-Za-z0-9_-]+/_/g; defined(\$ext) ? \"\$tmp.\$ext\" : \$tmp",
        ), "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO
