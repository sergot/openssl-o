use NativeCall;

class SSL_METHOD is repr('CStruct') {
    has int32 $.version;
}

class SSL_CTX is repr('CStruct') {
    has SSL_METHOD $.method;
}

class SSL is repr('CStruct') {
}

sub SSLv3_client_method() returns SSL_METHOD is native('libssl') { * }
sub SSL_CTX_new(SSL_METHOD) returns SSL_CTX is native('libssl')  { * }
sub SSL_new(SSL_CTX) returns SSL is native('libssl')             { * }

my $c = SSLv3_client_method();
my $ctx = SSL_CTX_new($c);
say $ctx.method;
my $ssl = SSL_new($ctx);
