package Plack::Middleware::DBIx::QueryLog;
use strict;
use warnings;
our $VERSION = '0.01';
use parent qw( Plack::Middleware );
use DBIx::QueryLog;
use Plack::Util::Accessor qw(
    explain
    useqq
    compact
    show_data_source
    skip_bind
    threshold
    probability
    color
    logger
    output_file
);

sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;

    my $self;
    if (@_ == 1 && ref $_[0] eq 'HASH') {
        $self = bless {%{$_[0]}}, $class;
    } else {
        $self = bless {@_}, $class;
    }
    $self->_init();

    $self;
}

sub _init {
    my $self = shift;
    DBIx::QueryLog->explain(1) if $self->explain;
    DBIx::QueryLog->useqq(1) if $self->useqq;
    DBIx::QueryLog->compact(1) if $self->compact;
    DBIx::QueryLog->show_data_source(1) if $self->show_data_source;
    DBIx::QueryLog->skip_bind(1) if $self->skip_bind;
    DBIx::QueryLog->threshold($self->threshold) if $self->threshold;
    DBIx::QueryLog->probability($self->probability) if $self->probability;
    DBIx::QueryLog->color($self->color) if $self->color;
    DBIx::QueryLog->logger($self->logger) if $self->logger;
    if( $self->output_file && open my $fh, '>>', $self->output_file ) {
        $DBIx::QueryLog::OUTPUT = $fh;
    }
}

sub prepare_app {
    my $self = shift;
}

sub call {
    my $self = shift;
    my ($env) = @_;
    my $res = $self->app->($env);
    return $res;
}


1;
__END__

=head1 NAME

Plack::Middleware::DBIx::QueryLog - middleware for DBIx::QueryLog

=head1 SYNOPSIS

  builder {
      enable "Plack::Middleware::DBIx::QueryLog",
          explain => 1,
          color => 'magenta';
      $app;
  };

=head1 DESCRIPTION

Plack::Middleware::DBIx::QueryLog is a middleware that use DBIx::QueryLog

=head1 CONFIGRATIONS

=over 4

=item explain

  explain => 1,

DBIx::QueryLog->explain(1);

=item useqq

  useqq => 1,

DBIx::QueryLog->useqq(1);

=item compact

  compact => 1,

DBIx::QueryLog->compact(1);

=item show_data_source

  show_data_source => 1,

DBIx::QueryLog->show_data_source(1);

=item skip_bind

  skip_bind => 1,

DBIx::QueryLog->skip_bind(1);

=item threshold

  threshold => 0.1,

DBIx::QueryLog->threshold(0.1);

=item probability

  probability => 100,

DBIx::QueryLog->probability(100);

=item color

  color => 'magenta',

DBIx::QueryLog->color('magenta');

=item logger

  logger => '', # Sets logger class

DBIx::QueryLog->logger($logger);

=item output_file

  output_file => 'query.log',

open my $fh, '>>', 'query.log';
$DBIx::QueryLog::OUTPUT = $fh;

=back

=head1 AUTHOR

dameninngenn E<lt>dameninngenn.owata {at} gmail.comE<gt>

=head1 SEE ALSO

L<DBIx::QueryLog>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
