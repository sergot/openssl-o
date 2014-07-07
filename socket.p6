my $sock = IO::Socket::INET.new(host => 'filip.sergot.pl');
my $fd = nqp::getattr(nqp::decont($sock), IO::Socket, '$!PIO');
