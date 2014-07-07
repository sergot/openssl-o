my $sock = IO::Socket::INET.new(host => 'filip.sergot.pl');
my $fd = nqp::getattr($sock, IO::Socket, '$!PIO');
