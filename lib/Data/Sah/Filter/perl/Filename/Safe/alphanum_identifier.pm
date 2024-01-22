package Data::Sah::Filter::perl::Filename::Safe::alphanum_identifier;

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
        summary => 'Replace characters that are not [A-Za-z0-9_] with underscore (_), avoid digit as first character',
        description => <<'MARKDOWN',

This is just like the `alphanum`
(<pm:Data::Sah::Filter::perl::Filename::Safe::alphanum_identifier>) filter
except with an additional rule: if the first character of the result is a digit
([0-9]) then an underscore prefix is added.

MARKDOWN
        might_fail => 0,
        args => {
        },
        examples => [
            {value => '', filtered_value => ''},
            {value => 'foo', filtered_value => 'foo'},
            {value => '123  456-789.foo.bar', filtered_value => '_123_456_789_foo.bar'},
            {value => 'a123  456-789.foo.bar', filtered_value => 'a123_456_789_foo.bar'},
            {value => '__123  456-789.foo.bar', filtered_value => '__123_456_789_foo.bar'},
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
            "my \$tmp = $dt; my \$ext; \$tmp =~ s/\\.(\\w+)\\z// and \$ext = \$1; \$tmp =~ s/[^A-Za-z0-9_]+/_/g; \$tmp = \"_\$tmp\" if \$tmp =~ /\\A[0-9]/; defined(\$ext) ? \"\$tmp.\$ext\" : \$tmp",
        ), "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO
