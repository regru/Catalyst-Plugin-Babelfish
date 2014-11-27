# NAME

Catalyst::Plugin::Babelfish - Locale::Babelfish for Catalyst

# VERSION

version 1.0

# SYNOPSIS

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

# DESCRIPTION

...

## CONFIGURATION

You can override any parameter sent to [Locale::Babelfish](https://metacpan.org/pod/Locale::Babelfish) by specifying
a `babelfish` hashref to the config section:

    __PACKAGE__->config(
        babelfish => {
            default_locale => 'en_US',
            dirs           => [ "/path/to/dictionaries" ],
            lang_param     => 'language',
        },
    );

All parameters equal to Locale::Babelfish except `lang_param`
this parameter for automatic language change.
Plugin will check parameter in GET-POST request, by default `lang`

# METHODS

## t

    $c->t( ... );

Short form for

    $c->l10n->t( ... );

## l10n

Babelfish object

    $c->l10n->t( ... )
    $c->l10n->has_any_value( ... )

and other methods

# SEE ALSO

[Locale::Babelfish](https://metacpan.org/pod/Locale::Babelfish)

[https://github.com/nodeca/babelfish](https://github.com/nodeca/babelfish)

# AUTHORS

- Akzhan Abdulin <akzhan@cpan.org>
- Igor Mironov <grif@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Igor Mironov.

This is free software, licensed under:

    The MIT (X11) License
