package Data::Sah::Filter::perl::Filename::Safe::alphanum;

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
        summary => 'Replace characters that are not [A-Za-z0-9_] with underscore (_)',
        description => <<'MARKDOWN',

Multiple consecutive unwanted characters will be replaced with a single
underscore.

A single filename extension is allowed, e.g. "foo bar.exe" -> "foo_bar.exe", but
additional filename extensions will be made 'safe' too, e.g. "foo bar.doc.pdf"
-> 'foo_bar_doc.pdf'. However, multiple filename extensions are allowed if you
set the `allow_multiple_exts` to true.

If you want to avoid having digit as the first character, use the
`alphanum_identifier`
(<pm:Data::Sah::Filter::perl::Filename::Safe::alphanum_identifier>) filter
instead.

MARKDOWN
        might_fail => 0,
        args => {
            allow_multiple_exts => {schema=>'bool*'},
        },
        examples => [
            {value => '', filtered_value => ''},
            {value => 'foo', filtered_value => 'foo'},
            {value => '123  456-789.foo.bar', filtered_value => '123_456_789_foo.bar'},
            {value => '123  456-789.foo.bar', filter_args=>{allow_multiple_exts=>1}, filtered_value => '123_456_789.foo.bar'},
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
            "my \$tmp = $dt; my \$ext; \$tmp =~ ".($gen_args->{allow_multiple_exts} ? "s/\\.(\\w+(?:\\.\\w+)*)\\z//" : "s/\\.(\\w+)\\z//")." and \$ext = \$1; \$tmp =~ s/[^A-Za-z0-9_]+/_/g; defined(\$ext) ? \"\$tmp.\$ext\" : \$tmp",
        ), "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO
