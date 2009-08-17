# A debhelper build system class for handling CMake based projects.
# It prefers out of source tree building.
#
# Copyright: © 2008-2009 Modestas Vainius
# License: GPL-2+

package Debian::Debhelper::Buildsystem::cmake;

use strict;
use base 'Debian::Debhelper::Buildsystem::makefile';

sub DESCRIPTION {
	"CMake (CMakeLists.txt)"
}

sub check_auto_buildable {
	my $this=shift;
	my ($step)=@_;
	my $ret = -e $this->get_sourcepath("CMakeLists.txt");
	$ret &&= $this->SUPER::check_auto_buildable(@_) if $step ne "configure";
	return $ret;
}

sub new {
	my $class=shift;
	my $this=$class->SUPER::new(@_);
	$this->prefer_out_of_source_building(@_);
	return $this;
}

sub configure {
	my $this=shift;
	my @flags;

	# Standard set of cmake flags
	push @flags, "-DCMAKE_INSTALL_PREFIX=/usr";
	push @flags, "-DCMAKE_VERBOSE_MAKEFILE=ON";

	$this->mkdir_builddir();
	$this->doit_in_builddir("cmake", $this->get_source_rel2builddir(), @flags, @_);
}

1