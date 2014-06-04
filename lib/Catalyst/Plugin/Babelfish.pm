﻿package Catalyst::Plugin::Babelfish;


=head1 NAME

Catalyst::Plugin::Babelfish - Locale::Babelfish for Catalyst

=head1 SYNOPSIS

    use Catalyst 'Babelfish';


    $c->set_lang('ru_RU');
    print $c->l10n->t('main.hello');

Use a macro if you're lazy:

   [% MACRO t(text, args) BLOCK;
       c.t(text, args);
   END; %]

   [% t('main.hello') %]
   [% t('main.test', { test => 1}) %]


=head1 DESCRIPTION


=head2 CONFIGURATION

You can override any parameter sent to L<Locale::Babelfish> by specifying
a C<babelfish> hashref to the config section:

    __PACKAGE__->config(
        babelfish => {
                        default_lang => 'en_US',
                        dirs         => [ "/path/to/dictionaries" ],
                        langs        => [ 'fr_FR', 'en_US' ],
                        lang_param   => 'language',
                     },
    );

All parameters equal to Locale::Babelfish except 'lang_param'
this parameter for automatic language change.
Plugin will check parameter in GET-POST request, by default 'lang'


=cut

use utf8;
use Modern::Perl;

use Locale::Babelfish;

our $babelfish = undef;
our $params    = undef;


=head1 METHODS

=method t

  $c->t( ... )

Short form for  $c->l10n->t(...)

=cut

sub t { my $self = shift; $babelfish->t( @_ ) }

=method l10n

  Babelfish object

  $c->l10n->t( ... )
  $c->l10n->has_any_value( ... )
  and other methods

=cut

sub l10n { $babelfish }


sub setup_finalize {
    my $class = shift;

    my $cfg   = $class->config;
    my $lcfg  = $cfg->{babelfish};
    $params->{lang_param} = $lcfg->{lang_param} || 'lang';

    $babelfish = Locale::Babelfish->new($lcfg, $class->log);

    $class->next::method(@_);
}

sub prepare {
    my $class = shift;
    my $c = $class->next::method(@_);
    my $lang = $c->request->params->{$params->{lang_param}} ? $c->request->params->{$params->{lang_param}} : $babelfish->default_lang;
    $c->set_lang($lang);

    return $c;
}


=method set_lang

  $c->set_lang( $lang )

  Setting language

=cut

sub set_lang {
    my ($c, $lang) = @_;
    $babelfish->set_context_lang($lang);
}


=method current_lang

  $c->current_lang

  Current language

=cut

sub current_lang {
    my $c  = shift;

    return $babelfish->context_lang;
}

=head1 SEE ALSO

L<Locale::Babelfish>

L<https://github.com/nodeca/babelfish>

=cut

1;
