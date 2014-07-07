my $sock = IO::Socket::INET.new(host => 'filip.sergot.pl');
my Mu $fd = nqp::getattr(nqp::decont($sock), IO::Socket::INET, '$!PIO');
