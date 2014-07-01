use NativeCall;

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
}

sub SSL_library_init() is native('libssl')                                 { * }
sub SSL_load_error_strings() is native('libssl')                           { * }
sub SSLv3_client_method() returns SSL_METHOD is native('libssl')           { * }
sub SSLv3_server_method() returns SSL_METHOD is native('libssl')           { * }
sub SSLv3_method() returns SSL_METHOD is native('libssl')                  { * }
sub SSL_CTX_new(SSL_METHOD) returns SSL_CTX is native('libssl')            { * }
sub SSL_new(SSL_CTX) returns SSL is native('libssl')                       { * }
sub SSL_shutdown(SSL) returns int32 is native('libssl')                    { * }
sub SSL_get_error(SSL, int32) returns int32 is native('libssl')            { * }
sub SSL_accept(SSL) returns int32 is native('libssl')                      { * }
sub SSL_connect(SSL) returns int32 is native('libssl')                     { * }
sub SSL_read(SSL, CArray[uint8], int32) returns int32 is native('libssl')  { * }
sub SSL_write(SSL, CArray[uint8], int32) returns int32 is native('libssl') { * }

SSL_library_init();
SSL_load_error_strings();

my $c1 = SSLv3_client_method();
my $c2 = SSLv3_server_method();
my $c3 = SSLv3_method();

my $ctx = SSL_CTX_new($c1);
say $ctx;
my $ssl = SSL_new($ctx);
say $ssl;

SSL_connect($ssl);
SSL_accept($ssl);

my $buf = CArray[uint8].new;
say SSL_read($ssl, $buf, 1);
say SSL_write($ssl, $buf, 1);

say SSL_get_error($ssl, SSL_shutdown($ssl));
