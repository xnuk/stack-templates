#!/usr/bin/env perl
# vim: ts=4 sw=4 noet

use strict;
use warnings;
use v5.24;

my $stackage = 'https://www.stackage.org/';
my $channel = 'lts';
my $resolver = `curl -sX HEAD -w '%{redirect_url}' $stackage$channel` or die;

if ($resolver =~ m|^$stackage($channel-[-0-9\.]+)| or die) {
	$resolver = $1;
}

for (grep { -f $_ && !m/\.(cabal|pl|hsfiles)$/n } <* **/* .*>) {
	print "{-# START_FILE $_ #-}\n";
	open (my $fh, '<', $_) or die;
	for (<$fh>) {
		s|\Q{{copyright}}\E|{{copyright}}{{^copyright}}{{year}} {{author}}{{/copyright}}|;
		s|\Q{{author}}\E|{{author-name}}{{#author-email}} <{{author-email}}>{{/author-email}}|;
		s|\Q{{resolver}}\E|$resolver|;
		print
	}
}

