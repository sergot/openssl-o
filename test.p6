use NativeCall;

class IO::Socket::SSL is IO::Socket::INET {
    # TODO
}

# bio.h {
class BIO_METHOD is repr('CStruct') {
    has int32 $.type;
    has Str $.name;
}

class BIO is repr('CStruct') {
    has BIO_METHOD $.method;
    # some functions ?
    has Str $.cb_arg;

    has int32 $.init;
    has int32 $.shutdown;
    has int32 $.flags;
    has int32 $.retry_reason;
    has int32 $.num;
    has OpaquePointer $.ptr;

    has BIO $.next_bio;
    has BIO $.prev_bio;

    has int32 $.references;
    has int $.num_read;
    has int $.num_write;

    # ex_data ?
}
# }

class SSL_METHOD is repr('CStruct') {
    has int32 $.version;
}

class SSL_CIPHER is repr('CStruct') {
    has int32 $.valid;
    has Str $.name;
    has int $.id;

    has int $.algorithm_mkey;
    has int $.algorithm_auth;
    has int $.algorithm_enc;
    has int $.algorithm_mac;
    has int $.algorithm_ssl;

    has int $.algo_strength;
    has int $.algorithm2;
    has int32 $.strength_bits;
    has int32 $.alg_bits;
}

class SSL_SESSION is repr('CStruct') {
    has int32 $.ssl_version;
}

class SSL_CTX is repr('CStruct') {
    has SSL_METHOD $.method;
}

class SSL is repr('CStruct') {
    has int32 $.version;
    has int32 $.type;

    has SSL_METHOD $.method;

    has BIO $.rbio;
    has BIO $.wbio;
    has BIO $.bbio;

    has int32 $.rwstate;

    has int32 $.in_handshake;

    # function
    has OpaquePointer $.handshake_func;

    has int32 $.server;

    has int32 $.new_session;

    has int32 $.quiet_shutdown;
    has int32 $.shutdown;

    has int32 $.state;
    has int32 $.rstate;
}

# init funcs
sub SSL_library_init() is native('libssl')                                 { * }
sub SSL_load_error_strings() is native('libssl')                           { * }

# method funcs
sub SSLv2_client_method() returns SSL_METHOD is native('libssl')           { * }
sub SSLv2_server_method() returns SSL_METHOD is native('libssl')           { * }
sub SSLv2_method() returns SSL_METHOD is native('libssl')                  { * }
sub SSLv3_client_method() returns SSL_METHOD is native('libssl')           { * }
sub SSLv3_server_method() returns SSL_METHOD is native('libssl')           { * }
sub SSLv3_method() returns SSL_METHOD is native('libssl')                  { * }
sub SSLv23_client_method() returns SSL_METHOD is native('libssl')          { * }
sub SSLv23_server_method() returns SSL_METHOD is native('libssl')          { * }
sub SSLv23_method() returns SSL_METHOD is native('libssl')                 { * }

# ctx funcs
sub SSL_CTX_new(SSL_METHOD) returns SSL_CTX is native('libssl')            { * }
sub SSL_CTX_free(SSL_CTX) is native('libssl')                              { * }

# ssl funcs
sub SSL_new(SSL_CTX) returns SSL is native('libssl')                       { * }
sub SSL_set_fd(SSL, int32) returns int32 is native('libssl')               { * }
sub SSL_shutdown(SSL) returns int32 is native('libssl')                    { * }
sub SSL_free(SSL) is native('libssl')                                      { * }
sub SSL_get_error(SSL, int32) returns int32 is native('libssl')            { * }
sub SSL_accept(SSL) returns int32 is native('libssl')                      { * }
sub SSL_connect(SSL) returns int32 is native('libssl')                     { * }
sub SSL_read(SSL, CArray[uint8], int32) returns int32 is native('libssl')  { * }
sub SSL_write(SSL, CArray[uint8], int32) returns int32 is native('libssl') { * }
sub SSL_set_connect_state(SSL) is native('libssl')                         { * }
sub SSL_set_accept_state(SSL) is native('libssl')                          { * }

SSL_library_init();
SSL_load_error_strings();

# CTX init
my $ssl_ctx = SSL_CTX_new( SSLv23_client_method() );
die 'context' unless $ssl_ctx.method;
say $ssl_ctx;

# SSL init
my $ssl = SSL_new($ssl_ctx);
die 'ssl' unless $ssl.method;

# SSL conf
# TODO : socket handle, now it's the stderr
sub client_connect(CArray[uint8], int32) returns int32 is native('./libclient') { * }
my $fd = client_connect(str-to-carray('filip.sergot.pl'), 443);
say "FD: ", $fd;
die 'set_fd' unless SSL_set_fd($ssl, $fd);

SSL_set_connect_state($ssl);
#SSL_set_accept_state($ssl);

# SSL conn
die 'connect' unless SSL_connect($ssl);

say $ssl;

# SSL write/read
my $s = "GET / HTTP/1.1\r\nHost: filip.sergot.pl\r\n\r\n";
say "write: ", SSL_write($ssl, str-to-carray($s), $s.chars);

sub get_buff(int32) returns CArray[uint8] is native('./libclient') { * }
my $to_read = 100;
my $c = get_buff($to_read);
my $read = SSL_read($ssl, $c, $to_read);
say "read == $read [{SSL_get_error($ssl, $read)}]: {$c[0..$read]>>.chr.join('')}";

# SSL end
until SSL_shutdown($ssl) {
    say "shutdown is 0";
}
SSL_free($ssl);

# CTX end
SSL_CTX_free($ssl_ctx);

# close socket
sub client_disconnect(int32) is native('./libclient') { * }
client_disconnect($fd);

sub str-to-carray(Str $s) {
    my @s = $s.split('');
    my $c = CArray[uint8].new;
    for 0 ..^ $s.chars -> $i {
        my uint8 $elem = @s[$i].ord;
        $c[$i] = $elem;
    }
    $c;
}
