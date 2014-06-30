use NativeCall;

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

class SSL_CTX is repr('CStruct') {
    has SSL_METHOD $.method;
}

class SSL is repr('CStruct') {
}

sub SSL_library_init() is native('libssl')                       { * }
sub SSL_load_error_strings() is native('libssl')                 { * }
sub SSLv3_client_method() returns SSL_METHOD is native('libssl') { * }
sub SSL_CTX_new(SSL_METHOD) returns SSL_CTX is native('libssl')  { * }
sub SSL_new(SSL_CTX) returns SSL is native('libssl')             { * }
sub SSL_shutdown(SSL) returns int32 is native('libssl')          { * }
sub SSL_get_error(SSL, int32) returns int32 is native('libssl')  { * }

SSL_library_init();
SSL_load_error_strings();

my $c = SSLv3_client_method();
my $ctx = SSL_CTX_new($c);
say $ctx;
my $ssl = SSL_new($ctx);
say $ssl;
say SSL_get_error($ssl, SSL_shutdown($ssl));
