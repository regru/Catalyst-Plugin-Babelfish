package Catalyst::Plugin::Babelfish;

# ABSTRACT: Locale::Babelfish for Catalyst

use utf8;
use strict;
use warnings;

use Locale::Babelfish;

# VERSION

=head1 SYNOPSIS

    use Catalyst 'Babelfish';

    $c->l10n->locale('ru_RU');
    print $c->l10n->locale;
    print $c->l10n->t('main.hello');

Use a macro if you're lazy:

    [% MACRO t(text, args) BLOCK;
        c.t(text, args);
    END; %]

    [% t('main.hello') %]
    [% t('main.test', { test => 1}) %]

=head1 DESCRIPTION

...

=head2 CONFIGURATION

You can override any parameter sent to L<Locale::Babelfish> by specifying
a C<babelfish> hashref to the config section:

    __PACKAGE__->config(
        babelfish => {
            default_locale => 'en_US',
            dirs           => [ "/path/to/dictionaries" ],
            lang_param     => 'language',
        },
    );

All parameters equal to Locale::Babelfish except C<lang_param>
this parameter for automatic language change.
Plugin will check parameter in GET-POST request, by default C<lang>

=cut

our $babelfish = undef;
our $params    = undef;

=method t

    $c->t( ... );

Short form for

    $c->l10n->t( ... );

=cut

sub t { my $self = shift; $babelfish->t( @_ ) }

=method l10n

Babelfish object

    $c->l10n->t( ... )
    $c->l10n->has_any_value( ... )

and other methods

=cut

sub l10n { $babelfish }

=for Pod::Coverage setup_finalize

=cut

sub setup_finalize {
    my $class = shift;

    my $cfg   = $class->config;
    my $lcfg  = $cfg->{babelfish};
    $params->{lang_param} = $lcfg->{lang_param} || 'lang';

    $babelfish = Locale::Babelfish->new( $lcfg );

    $class->next::method(@_);
}

=for Pod::Coverage prepare

=cut

sub prepare {
    my $class = shift;
    my $c = $class->next::method(@_);
    my $locale = $c->request->params->{$params->{lang_param}} || $babelfish->default_locale;
    $babelfish->locale($locale);

    return $c;
}

=head1 SEE ALSO

L<Locale::Babelfish>

L<https://github.com/nodeca/babelfish>

=cut

1;
